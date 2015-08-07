#
# Debate Summary - Croudsource arguments and debates
# Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>
#
# This file is part of Debate Summary.
#
# Debate Summary is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Debate Summary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
#
class IssuesController < ApplicationController
  cache_sweeper :issue_sweeper
  before_filter :authenticate_user!, :except => [:show, :list]
  before_filter :prevent_penalized_user_from_saving, only: [:update]
  before_filter :prevent_penalized_user_from_creating, only: [:create]
  after_filter :process_visit, only: [:show]
  before_filter :redirect_to_permanent_url, only: [:show]
  before_filter :get_contexts, only: [:new, :create, :edit, :update]

  def index
    if params[:user_id]
      @user = User.find params[:user_id]
      @issues = @user.activities.group('issue_id').collect {|a| a.issue }
      render 'user_index'
    else
      @issues = Issue.page(params[:page]).per(10)
    end
  end

  def list
    @issues = Issue.includes(:tags).all()
  end

  def report
    @issue = Issue.find(params[:id])
    if @issue
      ReportMailer.report_quality(@issue.id, current_user.id, params[:report][:problem]).deliver
    end
    respond_to do |format|
      format.html { redirect_to @issue, notice: "Report delivered. Our Admins will get back to you shortly once they have reviewed it." }
    end
  end

  def show

    if params[:tag_id]
      tag = Tag.find params[:tag_id]
      issue = Issue.find params[:id]
      if issue.tag_list.include?(tag.name)
        click = TagIssueClick.find_by_issue_id_and_tag_id(issue.id, tag.id)
        click = issue.tag_issue_clicks.new unless click
        click.tag_id = tag.id
        click.click_count += 1
        click.save
      end
      redirect_to issue_path(issue)
    else
      @issue = Issue.find params[:id]
      @issue_vote = IssueVote.new

      # @issue_all = Issue.all
      # @itst = @issue.issue_links.map  {|issue_link| issue_link.issue_id}
      # @itst.each do |issue_link|
      #   @issue2 = Issue.find params[:id => issue_link]
      # end

      @issue_vote_percent_up = IssueVote.where(:issue_vote_id => @issue.id, :up_or_down => "up").count
      @issue_vote_percent_down = IssueVote.where(:issue_vote_id => @issue.id, :up_or_down => "down").count
      @vote_total = @issue_vote_percent_up + @issue_vote_percent_down
      @ratings = Rating.where(:rateable_id => @issue.id).sum(:score)
      @ratings_count = Rating.where(:rateable_id => @issue.id).count
      @issue_vote_count = IssueVote.where(:issue_vote_id => @issue.id)
      @issue_detail_for = IssueVote.find(:first, :conditions => {:issue_vote_id => @issue.id, :cookie_id => request.session_options[:id], :yes_or_no => "for"})
      @issue_detail_against = IssueVote.find(:first, :conditions => {:issue_vote_id => @issue.id, :cookie_id => request.session_options[:id], :yes_or_no => "against"})
      @avg = @ratings / @ratings_count

      @detail_contexts = @issue.detail_contexts
      @detail_fors = @issue.detail_fors.sort_by(&:position).reverse
      @detail_againsts = @issue.detail_againsts.sort_by(&:position).reverse
      @detail_alternatives = @issue.detail_alternatives
      @detail_data = @issue.detail_data
      @detail_relevants = @issue.detail_relevants

      if session[:updated_issue]
        @updated_issue = true
        session.delete(:updated_issue)
      end
      respond_to do |format|
        format.html
        format.json { render json: @issue }
        format.pdf do
          render pdf: "#{@issue.filename}",
            disposition: 'attachment',
            template: 'issues/show.pdf.html.erb',
            layout: 'layouts/application.pdf.html.erb'
        end
      end
    end
  end

  def suggested_titles
    issue = Issue.find(params[:id])
    issue.setup_with_user(current_user)
    respond_to do |format|
      # format.html
      format.json { render json: issue.to_json(
        include: {
          suggested_titles: {
            include: {
              user: {
                only: [:name, :id]
              }
            },
            methods: [:current_score]
          }
        },
        methods: [:already_voted, :not_voted])
      }
    end
  end

  def new
    @issue = Issue.new
    @detail_contexts = [@issue.detail_contexts.new]
    @detail_fors = [@issue.detail_fors.new]
    @detail_againsts = [@issue.detail_againsts.new]
    @detail_alternatives = [@issue.detail_alternatives.new]
    @detail_data = [@issue.detail_data.new]
    @detail_relevants = [@issue.detail_relevants.new]
  end

  def create
    issue_ids = params[:issue].try(:delete, :issues_ids)


    @issue = current_user.issues.new params[:issue]
    Issue.where(id: issue_ids).each do |issue|
      @issue.issues << issue
    end

    %w(detail_contexts detail_fors detail_againsts detail_alternatives detail_relevants detail_data).each do |detail_type|
      array = []
      params[detail_type.to_sym].try(:each) do |detail|
        item = @issue.send(detail_type).new(detail.last)

        if item && item.invalid?
          @issue.errors.add(detail_type.to_sym, item.errors.full_messages.to_sentence)
        end

        if item.body.present?
          array << item
        end
      end
      instance_variable_set("@#{detail_type}", array)
    end

    if @issue.save
      @issue.process_links
      session[:updated_issue] = true
      current_user.activities.create(issue: @issue, activity_type: 'Create')
    end
    respond_to do |format|
      format.html do
        if @issue.persisted?
          redirect_to issue_path(@issue)
        else
          render 'new'
        end
      end
      format.js {}
    end
  end

  def edit
    @issue = Issue.find params[:id]
    @detail_contexts = @issue.detail_contexts
    @detail_fors = @issue.detail_fors.sort_by(&:position).reverse
    @detail_fors = [@issue.detail_fors.new] if @detail_fors.empty?
    @detail_againsts = @issue.detail_againsts.sort_by(&:position).reverse
    @detail_againsts = [@issue.detail_againsts.new] if @detail_againsts.empty?
    @detail_alternatives = @issue.detail_alternatives
    @detail_alternatives = [@issue.detail_alternatives.new] if @detail_alternatives.empty?
    @detail_data = @issue.detail_data
    @detail_data = [@issue.detail_data.new] if @detail_data.empty?
    @detail_relevants = @issue.detail_relevants
    @detail_relevants = [@issue.detail_relevants.new] if @detail_relevants.empty?
  end

  def update
    @issue = Issue.find params[:id]
    # NOTE: disable editing of title.
    params[:issue].delete(:title) if @issue.slug.present?

    @detail_contexts = @issue.detail_contexts
    @detail_fors = @issue.detail_fors
    @detail_againsts = @issue.detail_againsts
    @detail_alternatives = @issue.detail_alternatives
    @detail_data = @issue.detail_data

    # We need to set it before anything else, as in case only tags has changes, the issue won't be saved and tags lost
    @issue.tag_list = params[:issue][:tag_list]
    @issue.save

    issue_ids = params[:issue].delete(:issues_ids)
    Issue.where(id: issue_ids).each do |issue|
      @issue.issues << issue
    end
    related_issues = params[:issue].delete(:issues) || {}
    related_issues.each_pair do |id, keys|
      if keys.fetch('_destroy',nil)
        issue = Issue.find(id)
        @issue.issues.delete(issue)
      end
    end

    @issue.attributes = params[:issue]
    if @issue.valid? && ! @issue.changes.blank?
      issue_edit = current_user.proposed_edits.new({issue: @issue, editable: @issue, change_data: @issue.changes})
      issue_edit.closed_by = current_user if current_user.endorsed
      issue_edit.save
      issue_edit.accept! if current_user.endorsed
      activity_type = (current_user.endorsed? ? 'Edit' : 'EditRequest')
      current_user.activities.create(issue: @issue, proposed_edit: issue_edit, activity_type: activity_type)
      @issue.save
    end

    detail_ids = Detail.find_all_by_detailable_id_and_detailable_type(@issue.id, 'Issue').map{|d| d.id}
    %w(detail_contexts detail_fors detail_againsts detail_alternatives detail_relevants detail_data).each do |detail_type|
      params[detail_type.to_sym].try(:each) do |detail_params|
        detail_type_name = detail_type.split('_')[1].singularize
        if detail = Detail.find_by_id_and_detailable_type_and_detailable_id_and_detail_type(detail_params[0], 'Issue', @issue.id, detail_type_name)
          detail_ids.delete(detail.id)
          detail.attributes = detail_params[1]
        elsif ! detail_params.empty? && ! detail_params[1].nil? && ! detail_params[1].empty? &&
            ! (detail_params[1]['body'].blank? || detail_params[1]['title'].blank?)
          detail = Detail.new(detail_params[1].merge({detailable: @issue}) )
          detail.detail_type = detail_type_name
        end

        if ! detail.nil? && detail.valid? && (! detail.changes.empty? || detail.new_record?)
          detail_edit = current_user.proposed_edits.new({issue: @issue, editable: detail, detail_type: detail_type_name, change_data: detail.changes})
          detail_edit.closed_by = current_user if current_user.endorsed
          detail_edit.accept! if current_user.endorsed
          detail_edit.save

          if detail.new_record?
            activity_type = current_user.endorsed? ? 'Add' : 'AddRequest'
          else
            activity_type = current_user.endorsed? ? 'Edit' : 'EditRequest'
          end
          current_user.activities.create(issue: @issue, proposed_edit: detail_edit, activity_type: activity_type)
          detail.save
        else
          if detail && detail.invalid?
            @issue.errors.add(detail_type.to_sym, detail.errors.full_messages.to_sentence)
          end
        end

      end
    end

    Detail.delete(detail_ids)

    if @issue.errors.empty?
      @issue.process_links
      session[:updated_issue] = true
    end

    respond_to do |format|
      format.html do
        if @issue.errors.empty?
          redirect_to issue_path(@issue)
        else
          render 'edit'
        end
      end
      format.js {}
    end
  end

  # Show for history page, all data handaling done in the view

  def history
    @issue = Issue.find params[:id]
    params[:page] = params[:page].to_i
    # Note: hand pagination because of the non SQL select, yeauch
    @history_pagination_size = 5
    @activities = @issue.activities.latest.select { |a| ! a.empty_edits? }
    @pagination_from = @history_pagination_size * params[:page]
    @pagination_to = @pagination_from + @history_pagination_size - 1
    @activity_page = @activities[@pagination_from..@pagination_to]

    respond_to do |format|
      format.html{ render layout: 'full' }
      format.js{ }
    end
  end

  def all_comments
    @activity = Activity.find params[:activity_id]

    render :layout => false
  end

  #   Same process as the history page but elimates any statements not relating to id of the statement

  def statement
    detail = Detail.find(params[:id])

    @issue = detail.detailable

    @statements = ProposedEdit.where(editable_id: params[:id])
    #
    # Do not completely understand the bolted featured here, but to get this
    # page working we need to have a propsed_edit, activity and a user
    #
    # If there are no statements, a new one is created on the fly to resolve
    # backwards compatibility.
    #
    if @statements.empty?
      user = User.find_or_create_by_email!(
        email:"historic.edit@debatesummary.com",
        name: 'Historic Edit',
        password: 'changeme!123',
        password_confirmation: 'changeme!123'
      )

      proposed_edit = ProposedEdit.new
      proposed_edit.user = user
      proposed_edit.issue = @issue
      proposed_edit.change_data = YAML.dump({body: ['',detail.body]})
      proposed_edit.editable = detail
      proposed_edit.save!
      @activity = user.activities.create!(
        issue: @issue,
        proposed_edit: proposed_edit,
        activity_type: 'Add'
      )
      @issue.activities << @activity
    end

    respond_to do |format|
      format.html{ render layout: 'full' }
      format.json{ }
    end
  end

  private
  def process_visit
    if current_user
      current_user.visit(@issue, ip_address: request.ip.to_s)
    else
      Visit.create(visitable_id: @issue.id, visitable_type: @issue.class.to_s, ip_address: request.ip)
    end
  end

  def prevent_penalized_user_from_saving
    issue = Issue.find params[:id]

    redirect_to(issue, :alert => "You are not allowed to save that issue.") unless issue.user_allowed_to_edit? current_user
  end

  def prevent_penalized_user_from_creating
    redirect_to(root_url, :alert => "You are not allowed to create a new issue.") unless Issue.user_allowed_to_create? current_user
  end

  def redirect_to_permanent_url
    issue = Issue.find params[:id]
    if request.path.gsub(".#{params[:format]}", '') != issue_path(issue)
      return redirect_to(issue, status: :moved_permanently, format: params[:format])
    end
  end

  def get_contexts
    @contextualHelpDefault = Contextual.where(:title => "default help").first   || Contextual.new
    @contextualTitle = Contextual.where(:title => "page title").first           || Contextual.new
    @contextualContext = Contextual.where(:title => "context").first            || Contextual.new
    @contextualTags = Contextual.where(:title => "tags").first                  || Contextual.new
    @contextualOnSearch = Contextual.where(:title => "on search").first         || Contextual.new
  end
end
