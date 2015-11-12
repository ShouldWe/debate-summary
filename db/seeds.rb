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
# rubocop:disable Metrics/LineLength
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
Page.destroy_all
Template.destroy_all
Contextual.destroy_all
Template.create([
  { title: 'Welcome Email', slug: 'welcome-email', content: <<-EOF
<h1>Welcome to Debate Summary, {{user.name}}</h1>
<p>
You have successfully signed up to ShouldWe.
</p>
<p>
To login to the site, just follow this link: {{url}}.
</p>
<p>Thanks for joining and have a great day!</p>
  EOF
},

  { title: 'Expert Welcome Email', slug: 'expert-welcome-email', content: <<-EOF
<h1>You've been appointed as an Expert</h1>
<p>You've been made an expert for the Issue "{{issue.title}}", this means you can do the following:</p>
<p>You can view the issue at this link: <a href="{{issue.url}}">{{issue.title}}</a>.</p>
EOF
},

  { title: 'Endorse Email', slug: 'endorse-email', content: <<-EOF
<h1>You've been invited to become an endorsed member of Debate Summary</h1>
<p>You've been invited to become an endorsed member "{{user.name}}", this means you have been approved to become have editor abilities.</p>
<p>You should <a href="{{url}}">sign up</a> today.</p>
EOF
},

  { title: 'Unendorsed Email', slug: 'unendorse-email', content: <<-EOF
Unendorsed Email body
EOF
},

  { title: 'Alleged abuser decision made email', slug: 'alleged-abuser-decision-made-email', content: <<-EOF
<p>Dear {{user.name}}</p>
<p>There has been a complaint that you broke the house rules when you edited {{ issue_url }}</p>
<p>The rules broken were:</p>
{{ broken_rules }}
<p>The Debate Summary moderators have investigated the complaint and have decided on the response: {{rule_break_report.penalty_name}}</p>
<p>This is an automatic email</p>
EOF
},

  { title: 'Abuse Reported', slug: 'abuse-reported', content: <<-EOF
<p>
There is a new allegation of abuse. Please see {{rule_break_report_votes_url}}
</p>
EOF
},

  { title: 'Notification Subscription Created', slug: 'notification-subscription-created', content: <<-EOF
<p>Dear {{user.first_name}},</p>

<p>You have been subscribed to notifications on activity for the issue {{issue.title}} that you contributed to. If you would like to change your preferences about how often we notify you of new activity, or turn them off altogether, please go to {{user.account_link}}.</p>
EOF
},
  { title: 'Help Us', slug: 'help-us', content: <<-EOF
Help us spread the word about Debate Summary
[find out how](/help-us)
EOF
},
  { title: 'Homepage Featured Tags', slug: 'homepage-featured-tags', content: 'Tag_1, Tag_2, Tag_3, Tag_4' }
])

Page.create([
  { title: 'About', permalink: 'about', markdown: <<-EOF
##About Us
As well as giving any background to the site and who runs it, consider using this page to explain your moderation policy.
EOF
},
  { title: 'Style Guide', permalink: 'style-guide', markdown: <<-EOF
##Style Guide
An instructions page is recommended, giving users a step-by-step guide to creating and editing pages. Most importantly, this should explain the requirement to ensure every character in a sentence- including full stops- is hyperlinked, or the page will not upload successfully. It should also explain how signing in works (i.e. using Twitter, Facebook, LinkedIn etc.), and include any house style instructions you want.

See [www.shouldwe.org/style-guide](http://www.shouldwe.org/style-guide) as an example.
EOF
},

  { title: 'House Rules', permalink: 'house-rules', markdown: <<-EOF
## House Rules
Use this page to explain the rules of your community and and how any moderation works.
EOF
},

  { title: 'Contact', permalink: 'contact', markdown: <<-EOF
##Contact
Include all details here as desired.
EOF
},

  { title: 'Help us', permalink: 'help-us', markdown: <<-EOF
## Help us
As crowd-sourced platforms, websites that use DebateSummary are only as good as the contributions of their users. Consider including a page like this that makes it easier for them to get involved. E.g.

Link to your Twitter account or Facebook page

Link to your mailing list

Link to allow them to create a new page
EOF
}
])

Contextual.create([
  { title: 'page title', field_description: 'Enter a title for this page - use a question beginning "Should" and ending with a question mark', think_about: 'Keep the question short and unambiguous' },
  { title: 'context', field_description: 'Use this section to explain the background to the topic - what it\'s about and why it is important.', think_about: 'Text without a source of evidence will appear in red.  Add a source by selecting some text and clicking "Add source", then enter the URL of the source and click "OK".' },
  { title: 'for title', field_description: 'Summarise an argument in a single sentence of less than ten words","Three to five words is usually best', think_about: '' },
  { title: 'for body', field_description: 'Enter the main points behind the argument.  You can use multiple sentences but the total word count must not exceed 200 words. You should only enter arguments which have been made elsewhere.', think_about: 'About 100 words is usually best.  Click "New argument" to create another argument.' },
  { title: 'against title', field_description: 'Summarise an argument in a single sentence of less than ten words","Three to five words is usually best', think_about: '' },
  { title: 'against body', field_description: 'Enter the main points behind the argument. You can use multiple sentences but the total word count must not exceed 200 words. You should only enter arguments which have been made elsewhere.', think_about: 'About 100 words is usually best. Click "New argument" to create another argument.' },
  { title: 'alternative title', field_description: 'Sum up the perspective, trying to capture the essence of it in a few words.', placeholder: 'Insert argument heading' },
  { title: 'alternative body', field_description: 'Give a brief description of arguments which don\'t fit into the mainstream "yes" or "no" perspectives but which are still relevant.', think_about: 'Maybe use this section to document some "way out there ideas?' },
  { title: 'relevant title', field_description: 'Add a title to additional, relevant data to ensure people can see quickly what it contains.', placeholder: 'Insert argument heading' },
  { title: 'relevant body', field_description: 'This section can be used for pointing to relevant data that might not be directly cited in the main arguments.', think_about: 'If two different evidence sources support an argument, why not list them here?' },
  { title: 'tags', field_description: 'Tags help people find content by summing up its context in a few words or short phrases.  Note, you do not need to type a "#" symbol for your tags: just use normal text.', think_about: 'What are the big themes of this issue which people might search for?', placeholder: 'Some, tags, separated, by, commas...' },
  { title: 'on search', field_description: 'Search for topics which may be of interest to readers of this page', think_about: 'relevance is important: try not to add more than three or four links' },
  { title: 'default help', field_description: 'As you fill out the form, this sidebar will explain how to fill in each box.', think_about: ' how to keep your content brief and to the point.', field_title: 'Help' }
])
