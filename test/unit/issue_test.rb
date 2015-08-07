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
require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  test "all_invalid scope" do
    issue = create(:issue)
    issue.title = 'INVALID'
    issue.save(validate:false)
    issue.process_links

    issue2 = create(:issue)
    issue2.context = %Q{<a href="invalid">invalid</a>}
    issue2.save(validate:false)
    issue2.process_links

    HyperlinkExtractor.drain
    health = issue2.link_health.first
    health.status = 404
    health.save

    assert_equal 2, Issue.all_invalid.size
  end

  test 'broken_shas' do
    issue = create(:issue)
    detail = create(:detail)

    detail.body = %Q{<a href="invalid">invalid</a>}
    detail.save(validate:false)
    issue.details << detail
    issue.context = %Q{<a href="invalid">invalid</a>}
    issue.save(validate:false)
    issue.process_links

    HyperlinkExtractor.drain

    LinkHealth.all.each do |link|
      link.status = 404
      link.save
    end
    assert_equal Array, issue.broken_shas.class
    assert_equal 2, issue.broken_shas.size
  end

  test "validates presence of title" do
    subject = Issue.new(:title => "")
    refute subject.valid?
    assert_equal subject.errors[:title], ['can\'t be blank', 'is too short (minimum is 7 characters)', 'needs to be formatted starting with "Should" and ending with a Question-mark.']

    subject.title = "Should We Do Something?"
    subject.valid?
    assert subject.errors[:title].empty?
  end

  test 'validates presence of questionmark in title' do
    subject = Issue.new(title: 'Should contain question mark')
    refute subject.valid?
    assert_equal subject.errors[:title], ['needs to be formatted starting with "Should" and ending with a Question-mark.']
  end

  test "validates presence of context" do
    subject = Issue.new
    subject.valid?
    assert_equal ["can't be blank"], subject.errors[:context]

    subject.context = %q{<a href="#">Hello World</a>}
    subject.valid?
    assert subject.errors[:context].empty?
  end

  test "validate word length" do
    subject = Issue.new
    subject.context = invalid_description
    subject.valid?
    assert subject.errors[:context].any?
    assert_equal ["is too long (maximum is 200 words)"], subject.errors[:context]

    subject.context = valid_description
    subject.valid?
    assert subject.errors[:context].empty?, "expected #{subject.errors[:context]} to be empty"
  end

  test 'validates context is hyper linked' do
    subject = Issue.new
    subject.context = %Q{<a href="">valid</a> invalid}
    subject.valid?
    assert subject.errors[:context].any?
    assert_equal ['text must include evidence for all statements'], subject.errors[:context]
  end

  test 'validates context is hyper linked but not so strict' do
    subject = Issue.new
    subject.context = %Q{<a href="">valid</a> <a href="">valid</a>}
    subject.valid?
    assert subject.errors[:context].blank?
  end

  test "cleans content punctuation" do
    subject = Issue.new

    subject.body = %q{<a href="#">hello</a>, <a href="#">world</a>.}
    subject.valid?
    assert_equal %q{<a href="#">hello, </a><a href="#">world.</a>}, subject.body

    subject.body = %q{<a href="#">hello</a>, <a href="#">world</a>. <a href="#">having a nice day</a>?}
    subject.valid?
    assert_equal %q{<a href="#">hello, </a><a href="#">world. </a><a href="#">having a nice day?</a>}, subject.body
  end


  test "#description" do
    subject = Issue.new
    subject.context = %q{<a href="/">This is a description</a> <strong>from context</strong>}
    assert "This is a description from context", subject.description
  end

  test "returns content by sha" do
    subject = Issue.new
    subject.context = %q{<a href="/" name='123456'>This is a description</a> <strong>from context</strong>}
    assert "This is a description from context", subject.content_by_sha("123456")
  end

  test 'titleize title first letter only' do
    subject = create(:issue, title: 'Should we titleize the title OK?')
    assert_equal 'Should We Titleize The Title OK?', subject.title
  end

  test 'related issues' do
    subject = create(:issue)
    related = create(:issue)
    subject.issues << related
    assert_equal related, subject.issues.first
  end

  test 'removes empty elements' do
    subject = create(:issue, context: %q{<a href="#"> </a>})
    subject.save
    assert_equal '', subject.context
  end

  private

  def invalid_description
    content = ""
    500.times do
      content << %Q{<a href="">word</a> }
    end
    content
  end

  def valid_description
    content = ""
    199.times do
      content << %Q{<a href="">word</a> }
    end
    content
  end

end