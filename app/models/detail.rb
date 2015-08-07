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
class Detail < ActiveRecord::Base
  serialize :body_shas
  include HTMLPunctuationCleanup
  belongs_to :issue, touch: true
  has_many :statements, as: :statementable
  has_many :proposed_edits, as: :editable
  belongs_to :detailable, polymorphic: true
  has_many :link_health, as: :link_checkable, dependent: :destroy

  attr_accessible :title, :detail_type, :detailable, :detailable_type_id, :detailable_type, :issue_id, :body, :position
  attr_accessor :editor
  alias_attribute :body_shas, :shas

  validates :body,
    length: {
    maximum: 200,
    tokenizer: ->(str) { Nokogiri::HTML::fragment(str).text.strip.scan(/\b\S+\b/) }
  },
  hyper_link_content: true

  scope :has_statements, -> { where("exists (select 1 from statements where statementable_id = details.id and statementable_type = 'Detail')" ) }
  # has_paper_trail

  acts_as_list scope: [:detail_type, :detailable_id, :detailable_type], add_new_at: :top

  set_callback(:save, :before) do |document|
    set_hyperlink_attributes
    format_and_create_statements
  end

  after_initialize :format_body

  def self.format_body(raw_body)
    # html = Kramdown::Document.new(raw_body.to_s).to_html
    html = raw_body
    formatted_html = Sanitize.clean(html,
                                    :elements => ['a', 'p'],
                                    :attributes => {'a' => ['href', 'title', 'name']},
                                    :protocols => {'a' => {'href' => ['http', 'https']}}
                                   )
    clean_html = Sanitize.clean(html,
                                :elements => ['a'],
                                :attributes => {'a' => ['href', 'title', 'name']},
                                :protocols => {'a' => {'href' => ['http', 'https']}}
                               )
    [formatted_html, clean_html]
  end

  def self.statements(body)
    statements = []
    _, clean_html = Detail.format_body(body)

    doc = Nokogiri::HTML(clean_html)
    if doc.children[1]
      elements = []
      doc.children[1].child.children.each {|e| elements << {content: e.content, source: e.values.try(:first)} }
      elements.reject! {|e| e[:content].blank? }
      elements.each do |element|
        statements << {body: element[:content], source: element[:source]}
        # if statement = self.statements.find_by_position(i)
        #   statement.update_attributes(body: element[:content], source: element[:source])
        # else
        #   statement = self.statements.new(body: element[:content], source: element[:source])
        #   statement.position = i
        #   statement.save
        # end
      end
    end

  end

  def format_body
    self[:body] = body.try(:strip)

    formatted_html, clean_html = Detail.format_body(self[:body])
    self[:body] = clean_html
  end

  def format_and_create_statements
    formatted_html, clean_html = format_body

    doc = Nokogiri::HTML(clean_html)
    if doc.children[1]
      elements = []
      doc.children[1].child.children.each {|e| elements << {content: e.content, source: e.values.try(:first)} }
      elements.reject! {|e| e[:content].blank? }
      elements.each_with_index do |element, i|
        if statement = self.statements.find_by_position(i)
          statement.update_attributes(body: element[:content], source: element[:source])
        else
          statement = self.statements.new(body: element[:content], source: element[:source])
          statement.position = i
          statement.save
        end
      end
    end
  end

  def formatted_body
    self.body
  end
  deprecate :formatted_body

  def update_positions
    # we supress update_position code from acts_as_list
  end

  def content_by_sha sha
    anchors = Nokogiri::HTML::fragment(body).css('a')
    anchors.each do |anchor|
      if anchor['name'] == sha
        return anchor.inner_text
      end
    end
  end


  def context_title
    Contextual.find_by_title("#{detail_type} title") || Contextual.new
  end

  def context_body
    Contextual.find_by_title("#{detail_type} body") || Contextual.new
  end


  private

  def set_hyperlink_attributes
    shas = []
    doc = Nokogiri::HTML.fragment(body)
    doc.css('a').each do |node|
      if node.inner_text.strip.blank?
        node.remove
      else
        node['name']  = SecureRandom.hex(3) unless node['name']
        node['title'] = node['href'] if node['href']
        shas << node['name']
      end
    end
    self.shas = shas.uniq
    self.body = doc.to_html
  end
end