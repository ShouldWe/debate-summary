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
class ReportMailer < ActionMailer::Base
  def report_quality(issue_id, user_id, complaint)
    @issue = Issue.find(issue_id)
    @complaint = complaint
    @user = UserDecorator.decorate User.find(user_id)
    @site = {"url" => "#{Rails.env.development? ? "http://policywiki.dev" : "https://policywiki.herokuapp.com"}", "login_url" => "#{new_user_session_url}"}
    @template = Template.find('report-quality-email').liquid
    mail(
      to: User.admin_emails,
      subject: "[Debate Summary] Breach of quality report received"
    )
  end
end
