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

class DetailTest < ActiveSupport::TestCase

  teardown do
    class Detail::SecureRandom
      def self.hex(n)
        return ::SecureRandom.hex(n)
      end
    end
  end
  # setup do
  #   stub_secure_random
  # end
  test "has context title" do
    context = Contextual.create!(
      title: "for title",
      field_title: "Field Title Text",
      placeholder: "Placeholder Text",
      think_about: "Think About Text"
    )

    subject =  Detail.new(detail_type: "for").context_title
    assert_equal subject, context
    assert subject.respond_to? :title
    assert subject.respond_to? :placeholder
    assert subject.respond_to? :field_title
    assert subject.respond_to? :field_description
    assert subject.respond_to? :think_about
  end

  test "has context body" do
    context = Contextual.create!(
      title: "for body",
      field_title: "Field Title Text",
      placeholder: "Placeholder Text",
      think_about: "Think About Text"
    )

    subject =  Detail.new(detail_type: "for").context_body
    assert_equal subject, context
    assert subject.respond_to? :title
    assert subject.respond_to? :placeholder
    assert subject.respond_to? :field_title
    assert subject.respond_to? :field_description
    assert subject.respond_to? :think_about
  end

  test "formatting on initialize" do
    subject = Detail.new(body: %Q{<a href="http://www.google.com">hello world</a>})
    assert_equal %Q{<a href="http://www.google.com">hello world</a>}, subject.body
  end

  test "includes unique name attribute to body" do
    class Detail::SecureRandom
      def self.hex(n)
        '0eccb5'
      end
    end

    subject = Detail.new(body: %Q{<a href="http://example.com">hello world</a>})
    subject.save
    assert_equal %Q{<a href="http://example.com" name="0eccb5" title="http://example.com">hello world</a>}, subject.body

    class Detail::SecureRandom
      def self.hex(n)
        return ::SecureRandom.hex(n)
      end
    end
  end

  test "retains given name attribute to body" do
    subject = Detail.new(body: %Q{<a href="http://example.com" name="keepme">hello world</a>})
    subject.save
    assert_equal %Q{<a href="http://example.com" name="keepme" title="http://example.com">hello world</a>}, subject.body
  end

  test "returns content by sha" do
    subject = Detail.new(body: %Q{<a href="http://example.com" name="123456">hello world</a>})
    assert_equal "hello world", subject.content_by_sha("123456")
  end

  test "doesnt assign a title to be empty when href undefined" do
    subject = Detail.new(body: %Q{<a name="keepme">hello world</a>})
    subject.save
    assert_equal %Q{<a name="keepme">hello world</a>}, subject.body
  end

  test "validate body length" do
    subject = Detail.new
    subject.body = invalid_description
    subject.valid?
    assert subject.errors[:body].any?
    assert_equal ["is too long (maximum is 200 words)"], subject.errors[:body]

    subject.body = valid_description
    subject.valid?
    assert subject.errors[:body].empty?, "expected #{subject.errors[:body]} to be empty"
  end

  test 'validates body is hyper linked' do
    subject = Detail.new
    subject.body = %Q{<a href="">valid</a> invalid}
    subject.valid?
    assert subject.errors[:body].any?
    assert_equal ['text must include evidence for all statements'], subject.errors[:body]
  end

  test 'validates body is hyper linked but not so strict' do
    subject = Detail.new
    subject.body = %Q{<a href="">valid</a> <a href="">valid</a>}
    subject.valid?
    assert subject.errors[:body].blank?
  end

  test "cleans content punctuation" do
    subject = Detail.new

    subject.body = %q{<a href="#">hello</a>.  }
    subject.valid?
    assert_equal %q{<a href="#">hello.  </a>}, subject.body

    subject.body = %q{<a href="#">hello</a>, <a href="#">world</a>.}
    subject.valid?
    assert_equal %q{<a href="#">hello, </a><a href="#">world.</a>}, subject.body

    subject.body = %q{<a href="#">hello</a>, &nbsp;<a href="#">world</a>.}
    subject.valid?
    assert_equal %q{<a href="#">hello,  </a><a href="#">world.</a>}, subject.body, "handles html special characters"

    subject.body = %q{<a href="#">hello</a>, <a href="#">world</a>. <a href="#">having a nice day</a>?}
    subject.valid?
    assert_equal %q{<a href="#">hello, </a><a href="#">world. </a><a href="#">having a nice day?</a>}, subject.body
  end
  test 'removes empty elements' do
    subject = Detail.new
    subject.body = %q{<a href="#"> </a>}
    subject.save
    assert_equal '', subject.body
  end

  test "extract shas to column" do
    subject = Detail.new
    subject.body = %Q{<a href="http://example.com">Hello World</a>}
    subject.save
    assert_equal 1, subject.shas.length, 'Contains 1 SHA lookup'
  end

  test 'alias body_shas' do
    subject = Detail.new
    subject.shas = ['12345']
    assert_equal ['12345'], subject.body_shas
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