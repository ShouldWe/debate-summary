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

class LinkHealthTest < ActiveSupport::TestCase
  setup do
    refresh_body = <<EOS
      <META http-equiv="refresh" content="0;URL='http://destinationurl'">
EOS

    @redirecting_link = "http://aurlwithmetarefresh"
    stub_request(:get, @redirecting_link).to_return(:status => 200, :body => refresh_body)

    @non_redirecting_link = "http://aurlwithoutmetarefresh"
    stub_request(:get, @non_redirecting_link).to_return(:status => 200, :body => 'nothing to see here')
    @totally_broken_link = "http://totallyBrokenURL"
    stub_request(:get,@totally_broken_link).to_raise(Timeout::Error.new)

    @final_page = "http://destinationurl"

  end

  test 'Check link should detect meta redirect' do
    subject = LinkHealth.create!(url: @redirecting_link)
    resp = subject.get_url_response

    url = subject.detect_meta_redirect(resp.read)
    assert_equal @final_page, url
  end

  test 'returns nil for no meta redirect found' do
    subject = LinkHealth.create!(url: @non_redirecting_link)
    resp = subject.get_url_response
    url = subject.detect_meta_redirect(resp.read)
    resp = subject.get_url_response
    assert_equal nil, url
  end

  test "Should change url to be saved" do
    subject = LinkHealth.create!(url: @redirecting_link)
    subject.check_link
    assert_equal @final_page, subject.url
  end

  test "Should not change url to be saved" do
    subject = LinkHealth.create!(url: @non_redirecting_link)
    subject.check_link
    assert_equal @non_redirecting_link, subject.url
  end

  test 'handles broken link' do
    subject = LinkHealth.create!(url: @totally_broken_link)
    subject.check_link
    assert_equal 500, subject.status
    assert_match %r{Timeout::Error :}, subject.error_reason
  end

  test 'extract hyperlinks for issue' do
    resource = create(:issue)
    LinkHealth.extract_hyperlinks(resource)
    LinkHealth.extract_hyperlinks(resource)
    assert_equal 1, LinkHealth.count
  end

  test 'extract hyperlinks for detail' do
    resource = create(:detail)
    resource.body = %Q{<a href="http://example.com">Hello World</a>}
    resource.save
    LinkHealth.extract_hyperlinks(resource)
    LinkHealth.extract_hyperlinks(resource)
    assert_equal 1, LinkHealth.count
  end

  test 'updates the content url' do
    resource = create(:issue)
    LinkHealth.extract_hyperlinks(resource)
    lh = LinkHealth.last
    lh.url = 'http://differenturl'
    lh.save
    lh.update_content_url
    assert_match %r{http://differenturl}, lh.link_checkable.body
  end

  test "destroy redundant links" do
    subject = create(:issue)
    subject.context = %Q{<a href="http://example.com">Hello World</a> <a href="http://example.com/1">Hello World</a>}
    subject.save!

    subject.context = %Q{<a href="http://example.com">Hello World</a>}
    subject.save!
    subject.process_links
    HyperlinkExtractor.drain
    assert_equal 1, subject.link_health.count
  end

end