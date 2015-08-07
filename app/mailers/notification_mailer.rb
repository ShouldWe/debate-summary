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
# coding: utf-8
require 'premailer'

# NotificationMailer
class NotificationMailer < ActionMailer::Base
  layout 'email'
  helper :notification_mailer

  def page_for_period(period, user, report)
    period = period.to_s.humanize
    @user = user
    @report  = report
    message = mail(
      subject: "[Debate Summary] #{period} activity for pages",
      to:       user.email
    )
    # premailer(message)
  end

  def comments_edit_i_made_for_period(period, user, report)
    period = period.to_s.humanize
    @user = user
    @report  = report
    message = mail(
      subject: "[Debate Summary] #{period} comments on edits I made",
      to:       user.email
    )

    # premailer(message)
  end

  def comments_edit_i_commented_for_period(period, user, report)
    period = period.to_s.humanize
    @user = user
    @report  = report
    message = mail(
      subject: "[Debate Summary] #{period} comments on edits I commented on",
      to:       user.email
    )
    # premailer(message)
  end

  private

  def premailer(message)
    # message.text_part.body = Premailer.new(
    #   message.text_part.body.to_s,
    #   with_html_string: true
    # ).to_plain_text
    message.html_part.body = Premailer.new(
      message.html_part.body.to_s,
      with_html_string: true
    ).to_inline_css

    message
  end
end
