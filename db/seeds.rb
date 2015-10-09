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
}
])

Page.create([
  { title: 'About', permalink: 'about', markdown: <<-EOF
## About us

Debate Summary is a open-source version of ShouldWe. A non-partisan, crowd-sourced online guide to public policy debates and evidence.

Every page debates a specific public policy, explains who advocates it and outlines the main arguments for and against. Every single sentence on ShouldWe has to be hyperlinked to evidence,  so you can dive deeply in to the data if you choose.

By empowering the crowd to aggregate the most authoritative policy information, from all sides, in one place, we help journalists, researchers, campaigners, policy-makers and citizens to place each argument and piece of evidence in its proper context.

ShouldWe is a crowd-sourced evidence catalogue, not a group blog. ShouldWe pages are neither news reports nor opinion pieces. Instead, we deliver a 5-minute, unbiased, evidence-led overview of each live public policy debate. We will only ever be as good as our “crowd” so please do click below for different ways to get involved.

As a not-for-profit organisation we very much appreciate any time and talent you can contribute as we work to improve our democratic debate. 


## Thanks

We would not be where we are today without the thoughtful contributions and hard work of a whole range of people. We would particularly like to thank:

* Our earliest funders, who took the risk to support us from the back-of-the-envelope through to this point: The Open Society Foundations, The Bertha Foundation, Betterworld, ShouldWe's own trustees
* All of those who participated in each of our ‘brains trusts’, from which we learnt so much: journalists, technology gurus, political types and community organisers
* TaylorWessing, who provided a great deal of pro bono legal support to get us up-and-running
* Our early circle of ShouldWe-ers, who helped us organise events, sort out administration, and contributed many of the earliest ShouldWe pages
* The whole ShouldWe tribe! Every single person who has taken any time to help us solve a problem, to write a whole ShouldWe, to correct something, to give us a connection

We're hugely grateful to you all!
EOF
},
  { title: 'Style Guide', permalink: 'style-guide', markdown: <<-EOF
## Creating a Debate Summary page

Thanks so much for creating or editing a Debate Summary page. This should tell you everything you need to know, but if anything isn’t clear please let us know at hello@Debate Summary.org.

If you haven’t seen it yet, please take a look at our introductory video [here](http://video.shouldwe.org/). It’s just two minutes long. Watching the video and looking at some of the pages already on the site is the best way to get a feel for Debate Summary. Once you’ve done that you can create a Debate Summary page in just 7 easy steps.

**Step 1:**

Login / sign up using your Twitter, Facebook or LinkedIn profile. When you first register Debate Summary asks you to create a user profile. We do that so that readers who want to understand who created or edited a page can find out and so that, if you’d like, journalists can contact you for more details. Please don’t be shy about showcasing your expertise!

**Step 2:**

Decide what you’re going to call your page. It should start Debate Summary …? The ‘we’ in question should be a specific public markdown, ideally the UK government. The question can be about creating, or abolishing, or reinstating something and should reflect a public policy proposition currently being debated by policy-makers or an idea being proposed by a think tank, charity, university, research institute or political party. The question should be phrased neutrally (e.g. ‘Debate Summary introduce the Alternative Vote for UK General Elections?’ not ‘Should we have fair votes?’). Use the search function on Debate Summary's home page to see if there's already a page on your chosen topic.  If there isn't, click the "...or create a new issue" option at the bottom of the search results.

**Step 3:**

Fill in the issue detail and context box. Every word on a Debate Summary page needs to be hyperlinked to evidence, including in this box. It should be a neutral statement of who is proposing what, with links to online evidence which proves this is a genuine matter of live public debate. Debate Summary is not a place to debate abstract questions (‘Debate Summary prioritise civil liberties over public safety?’), but a place to evaluate specific policy ideas (‘Debate Summary abolish anti-social behaviour orders?’). If your question fits squarely in the second box it should be easy to link to recent news report where government ministers or a think tank has proposed a specific change to legislation or a new policy. If you are struggling to find links for this section, the question you are asking needs to be refined.

**Step 4:**

Fill in different arguments under the Yes and No headers. You can separate arguments with multiple headings under Yes and No, to make it clear people end up on the same side for different reasons. For example some people think we should have a minimum price on alcohol for public order reasons about town centres at closing time, while other advocates are more interested in the evidence about the impact on public health. You can list multiple arguments under each column, just remember that every word under each heading needs to be linked to an original source of evidence. Obviously whole sentences and indeed paragraphs can be hyperlinked to the same source, but you can’t miss out any words like you would in a blog. Even a missed full stop will mean your content cannot be uploaded. Please do include as many hyperlinks in a sentence as are necessary to evidence it.  Diverse presentations of evidence are actively welcomed on Debate Summary – linking to graphs, videos, podcasts, slideshows and infographics is encouraged.

**Step 5:**

Add "Leading Voices". This is where you can add the name of a notable participant in debate about this topic: for example an academic, or knowledgable journalist, or other thought leader.  It may be helpful to add a link to their online biography, perhaps at their university department or on their LinkedIn profile.

**Step 6:**

The "Notable Resources" space exists to direct readers to outlets which may not have been hyper-linked in that particular page, but which will provide useful authoritative background for readers. A page on the migration cap, for example, might usefully use the external links section to direct people towards the Migration Observatory at Oxford University, not simply Oxford University. Likewise a page on the EU referendum might include links to the Tax Payers’ Alliance EU blog, not simply the Tax Payers’ Alliance. This section is not, in other words, simply a space for brand building for organisations but a place to showcase other sources of tailored information for the specific readers of that page.

**Step 7:**

Please fill in tags. This is what enables the site to generate the news feed down the right hand side, and also what ensures your page will show up in the right section of Debate Summary’s home page.

## Some thoughts on style

**Tone:**  Debate Summary is predicated on the idea that policy-making involves making trade-offs and balancing priorities, and that people may legitimately come to different conclusions from shared evidence. The tone of contributions, therefore, should be neutral rather than polemical. Don’t try to be an ‘advocate’ for the evidence, just write descriptive sentences which state clearly what the evidence being linked to demonstrates. It isn’t your job to put the best possible ‘gloss’ on it or inspire people to read it with moving rhetoric. Avoid all gossip, innuendo, sarcasm and, of course, libel and defamation.
**Length:** The average reader should be able to understand the main points in 10 minutes. The linked evidence of each page would, of course, take much longer to read, watch or listen to, but the page itself should be accessible to and useful for somemarkdown putting together a news story under time pressure.
**Shelf life:** Please review your content to ensure it won’t date easily. For example, instead of ‘this year’ please say ‘in 2014’.
**Clarity:** Debate Summary is aimed at intelligent general readers. Please, therefore, take care to avoid jargon and acronyms. Write in clear British English as concisely as possible.

## A note about facts and evidence
All statements in Debate Summary must be verifiable facts, not opinions. For example:
(A) "The national minimum wage increased by over 70% between 1999 and late 2013".  This is a FACT, verifiable using figures here: <http://www.theguardian.com/news/datablog/2013/oct/01/uk-minimum-wage-history-in-numbers>
(B) "The national minimum wage leads to reduced employment". This is an OPINION which is not universally held: for example counter evidence here:
<http://wrap.warwick.ac.uk/1560/1/WRAP_Stewart_twerp630.pdf>
(C) "The Institute of Economic Affairs believe that 'research overall points to the minimum wage reducing employment'" is a FACT, verifiable here:
<http://www.iea.org.uk/blog/unemployment-and-the-minimum-wage>

In this example, statements (A) and (C) would be acceptable, but statement (B) would not.  However, statement (B) can be made acceptable by stating clearly *who* believes the statement to be true.

Not all sources are created equal, and a respected source is preferable to a less respected one.  In general, sources which are more likely to be considered reliable by moderators and readers are documents or other sources of information which:

* Are written by authors whose **credibility** on the topic is likely to be strong, and where the nature of any discernible bias is clear
* Are **peer-reviewed** either by communities of scholars or a community of practice, for example a document produced by a trade industry association may be considered reliable (noting comments about the transparency of affiliation, below)
* Are either **quantitative or qualitative** in nature
* Are written by an author or authors with a **relevant professional affiliation** (i.e. evidence produced by members of the general public should be investigated further)
* Are **unlikely to contain data which has been superseded** by more recent publications, or where the currency of the information contained within them is not compromised by the age of the document
* Readily show available biographical **information on the author**, or details of individuals behind any organisation publishing the evidence. As a general rule, information published anonymously is unlikely to be suitable as a reference on Debate Summary.  While the fact that a company or organisation has a stake in the evidence it advances doesn’t mean it is false, it does mean that it may be useful to find additional sources
* Have been obtained in a manner which is **repeatable and verifiable** by others

## Checklist

Once you’ve made a Debate Summary page, please apply this checklist before publishing:

* Is  my page title as specific, clear and neutral as possible?
* Does my policy proposition box detail the precise proposal and its origin?
* Does each argument on my page have an easy to understand and neutral title?
* Does my page have a diversity of sources and evidence types? Do they conform to Debate Summary’s evidence standards?
* Would a smart generalist, reading my page, understand the what, who and why of this issue in ten minutes? Is the page as readable and clear as possible?
* Have I tagged my page?
* Would a fair-minded general reader consider this page balanced and free of bias – in particular party political bias
* Have I completed my user page?
* Have I reviewed all of the content for shelf-life issues?
* Have I given myself a huge pat on the back for helping make our democratic debate richer and more accessible?

**Thank you!**

We are thrilled by your interest in Debate Summary and hugely appreciate your early adoption of our platform. Thank you from all of us at Debate Summary – we couldn’t make this happen without you.
EOF
},

  { title: 'House Rules', permalink: 'house-rules', markdown: <<-EOF
## House Rules

Debate Summary is an open environment where everyone is invited to improve our record of public debates. To ensure the quality of information on Debate Summary is kept high we have a few House Rules which we ask you to respect.

Every statement on a Debate Summary issue page must be:

1. Accurate, verifiable and fair (in the context of the information surrounding it)
2. Up-to-date and relevant
3. Evidenced with a working hyperlink to the best available source on the internet
4. As brief as possible
5. Perfect in grammar and spelling
6. In plain (British) English without jargon
7. Consistent with the other information surrounding it (in tone and content)
8. Polite, always
9. Reflective of any previous judgements about breaches of house rules (you may not post an identical or similar edit to one which has already been declared unacceptable by Debate Summary's moderators)
10. In line with Debate Summary's legal requirements, including respecting copyright (see below)

Please also make sure to follow the guidelines about evidence quality [here](/style-guide)

## Moderation
Statements on Debate Summary are not automatically moderated.  If you believe that content on Debate Summary breaches the House Rules above you should flag it for moderation.  The easiest way to do this is to click on the offending statement.  It will appear in a box on the right hand side of the page.  Scroll down the box till you find the link for "Comments".  Click that link to see the history of edits to that statement.  Identify the edit when the author made the change which you believe breaches the House Rules. Click "Flag as inappropriate" and follow the on-screen instructions to submit your objection.  The original author will be notified that the edit has been flagged for moderation, but will not know that you flagged it.

Our moderators will be automatically notified that you have flagged the text, and will decide whether the house rules have been breached, usually within a week.  If the breach is serious, the offending user may find their ability to edit that issue page, or the whole of Debate Summary, suspended for a period of time.

## Legal requirements

You must not post or send anything which:

* is or may be:
  * defamatory, derogatory, fraudulent, degrading, abusive, hateful, false, misleading, inaccurate, untrue, malicious, offensive, harassing, threatening or racist;
  * obscene, vulgar, indecent, pornographic or of a sexual nature;
  * a violation of another person's privacy;
  * a breach of confidentiality;
  * a computer viruses or other malicious or harmful code;
  * identifiable information about living people who are not the subject of legitimate political debate without their direct consent, or, in the case of people under 16, the consent of their parent or guardian.
* causes or is likely to cause anyone:
  * alarm, annoyance, anxiety, embarrassment, offence or distress;
  * incitement to racial or religious hatred;
* infringes any intellectual property rights, such as copyright and trademarks.  This means generally that you must own the rights in everything you post or must obtain permission from the rights owner to post the information;
* could prejudice any active legal proceedings of which you are aware;
* is unlawful or promotes or teaches unlawful activity;

You must not:

* impersonate anyone else or otherwise misrepresent your identity or status;
* hold yourself out as an employee or representative of Debate Summary or anyone affiliated with Debate Summary;
* stalk or harass or make persistent or regular contact with other users without their consent or encouragement or after any consent or encouragement has, expressly or impliedly, been withdrawn;
* use our website or Services in a way that might damage our name or reputation or that of any of our affiliates;
* use Debate Summary for any illegal activity or provide material which promotes or teaches illegal activity;
* advertise or offer to sell products or services, except where this is expressly permitted by our website (in which case you must comply with any terms relating to such use that we specify).
EOF
},

  { title: 'Legal', permalink: 'legal', markdown: <<-EOF
## Debate Summary Terms of Use

Debate Summary.org is run by the Policy Wiki Educational Foundation. The Foundation is UK-based not-for-profit whose mission is to improve the understanding of public policy debates, the quality of public policy-making and democratic scrutiny. Companies House Reg: 08098338. &nbsp;

### Introduction

These are the Terms of Use for Debate Summary [Debate Summary.org] (and any app we may develop for Debate Summary for mobile devices) ("Site"). The Site is operated by Policy Wiki Educational Foundation, operating as Debate Summary (we, us and our). We are a not for profit limited company registered in England and our registered company number is 08098338. Our address is 7 Chancellors Wharf, Crisp Road, London W6 9RT.

The Site offers Users who register with us through the Site (“Users”) the opportunity, subject to these Terms of Service, to view and participate in online articles and contributions on selected subjects of public interest and policy.&nbsp;&nbsp;

Your use of the Site is subject to these Terms of Use and by using the Site you agree to be bound by these Terms of Service.&nbsp; If you do not agree to any part of these Terms of Use, do not use the Site.

You should print a copy of these terms and conditions for future reference.

Use of your personal information submitted to or through the Site is governed by our Debate Summary Privacy and Cookies Policy. [link]

We reserve the right to change these Terms of Use from time to time by changing them on the Site and you are responsible for checking the current terms on the Site. These Terms of Use were last updated on 19 May 2013.



**Registering with us**

Anyone can view Debate Summary and its content, without the need to sign up, but subject to these Terms of Use.&nbsp; Anyone can join and become a contributor, once they have registered to set up an account with us by completing the account registration form available on the Site.&nbsp; We call users who have signed up "Contributing Users".&nbsp;&nbsp;&nbsp;&nbsp; You only need to register once. Registration is subject to approval by us in all cases, and we reserve the right, in our sole and absolute discretion, to decline any application for registration, without giving a reason.

To register with us, you must be at least 18 years of age (or any older age legally required under local law to bind yourself legally to these Terms of Service);

To register with us, you must provide us with accurate, complete and up-to-date contact information, including your name and email address. You are responsible for the information you provide to us. You must Contact us promptly to inform us of all changes to this information.

It is your responsibility to ensure you satisfy the age eligibility criteria set out above before choosing to register with us. By so registering, you represent and warrant to us that you do meet the age eligibility criteria.

**Usernames and passwords**

Upon registration for an account with us as a Contributing User, you will be asked to create a password. You must keep your login details confidential at all times and use it only to access and use your account and not for any other purpose. You are the only authorised user of your account and, accordingly, you must not disclose your login details to anyone else. You should Contact us immediately upon discovering any unauthorised use of your account or error in the operation of your login details. Any breach of these Terms of Use and/or any use of your account by anyone to whom you disclose your login details will be treated as if the breach or use had been carried out by you, and will not relieve you of your obligations to us.

You must cease to use your password to access your account upon termination of your account for whatever reason.

**User Content standards**

These standards apply to any and all contributions, edits, comments, links and other content of any kind you submit to or through the Site (“User Content”). You must comply with the spirit of the following standards as well as the letter. The standards apply to each part of any User Content as well as to its whole.

User Content must:

* be relevant to the purpose of the Site;

* where it states facts, be accurate to the best of your knowledge, information and belief;

* comply with applicable law in the United Kingdom and in any country from which it is submitted.

* be clean and concise and respectful of others’ views.

User Content must not:

* contain any material which infringes any intellectual property right or other right of any other person;

* be made in breach of any legal duty owed to a third party, such as a contractual duty or a duty of confidence or data protection obligations;

* offer or advertise any goods or services or any business or commercial enterprise or seek donations for any cause, whether political, charitable or otherwise other than the Site itself;

* contain any hyperlink to any page of an internet site that is prohibited by the site operator;

* contain any material which is defamatory of any person or entity;

* be likely to mislead or deceive any person;

* be used to impersonate any person, or to misrepresent your identity or affiliation with any person;

* contain any material which is obscene, offensive, hateful or inflammatory;

* be menacing, threatening, abuse or invade another´s privacy, or cause harassment, anxiety, alarm, upset, embarrassment, annoyance or inconvenience to any person;

* contain or promote sexually explicit material;

* promote violence or aggression;

* promote discrimination based on race, gender, religion, nationality, disability, sexual orientation or age;

* encourage, advocate, promote, solicit, invite or assist any illegal activity or unlawful act such as (by way of example only) intellectual property infringement or computer misuse;

* be used to transmit, or procure the sending of, any unsolicited or unauthorised advertising or promotional material or any other form of similar solicitation (spam);

* contain any viruses, Trojan horses, worms, time-bombs, keystroke loggers, spyware, adware or any other harmful programs or similar computer code designed to adversely affect the operation of any computer software or hardware;

* give the impression that it emanates from us, if this is not the case;

Right to submit and use User Content

You acknowledge that you are responsible for ensuring that you have the right to submit all User Content you submit to or through the Site and that no such User Content breaches the User Content standards set out above.

By submitting any User Content you represent and warrant to us that you have the right to submit that User Content and that it does not breach the User Content standards set out above.

You agree to indemnify us, on demand, against all losses, liabilities, amounts paid in settlement, and reasonable costs and expenses suffered or incurred by us as a result of any claim arising out or in connection with any User Content you submit to or through the Site, or any use you make of the Site otherwise than in accordance with these Terms of Use. This indemnity will survive termination or closure of your account for whatever reason.

We reserve the right, in our sole discretion, to delete, edit or modify any User Content submitted by you, at any time, with or without notice to you.

Licensing of User Content



By uploading or posting User Content to the Site, you direct us to store such User Content on our servers. To the extent that it is necessary for us to provide you with such a hosting service, to undertake any of the tasks set out in these Terms of Use and/or to enable your use of the Site, you hereby grant licences to us to do so on a worldwide, royalty-free, perpetual, non-exclusive, sub-licensable basis.

By uploading or posting User Content to the Site, you grant a worldwide, royalty-free, perpetual, non-exclusive, sub-licensable licence to other Users and to operators and users of any other websites, apps and/or platforms to which your User Content has been shared or embedded (the “Linked Services”) to use each item of such User Content for any purpose whatsoever, including but not limited to copying, reposting, transmitting or otherwise distributing, publicly displaying, publicly performing, adapting, preparing derivative works of, compiling, collecting, aggregating, making available and otherwise communicating to the public such User Content and doing any act which would otherwise infringe your moral rights.

The above rights are granted separately with respect to each item of User Content that you upload to the Site and may be exercised in all media and formats whether now known or developed in the future, and include the right to make such modifications as are technically necessary to exercise the rights in other media and formats.

Nothing in this section affects your continued ownership of intellectual property rights in any User Content you submit. The rights granted by this licence are subject to any restrictions, limitations and qualifications which are expressly stated in such User Content.

The licence granted in this section shall not require any User to credit or attribute your User Content to you. However, a User may not falsely or misleadingly credit or attribute your User Content to himself or to any third party. Furthermore, a User may not assert or imply any connection with, sponsorship or endorsement by you or your User Content in connection with their use of your User Content, without your separate, express prior written agreement.

You hereby acknowledge and agree that once you upload or post User Content to the Site, that User Content may, at our absolute discretion, remain hosted on the Site in perpetuity. You also acknowledge and agree that we are under no obligation to ensure deletion of your User Content from any servers or systems operated by us or by the operators of any Linked Service, or to require that any User or user of any Linked Service deletes any item of your User Content, even if you request such deletion.

If the standard suite of rights granted under applicable copyright law includes additional rights not granted under this licence, such additional rights are deemed to be included in this licence; this licence is not intended to restrict the licence of any rights under applicable law.

We are not a party to the licence granted in this section and we make no warranty or representation and grant no authority or right in relation to User Content. We are not liable to and User or third-party for acts carried out in relation to User Content.

**Access to the Site**

It is your responsibility to ensure your computer system meets all the necessary technical specifications to enable you to access and use the Site and is compatible with the Site.

We cannot guarantee the continuous, uninterrupted or error-free operability of the Site. There may be times when certain features, parts or content of the Site, or the entire Site, become unavailable (whether on a scheduled or unscheduled basis) or are modified, suspended or withdrawn by us, in our sole discretion, without notice to you.&nbsp; You agree that we will not be liable to you or to any third party for any unavailability, modification, suspension or withdrawal of the Site, or any features, parts or content of the Site.

**Site Content – what you are allowed to do**

Site Content means the look and feel of the Site and all content we have created or had created in relation to the Site, but not the User Content that You and other Users have submitted. You may only access and use the Site in accordance with these Terms of Use. You may retrieve and display the Site Content on a computer screen and, subject to the next section, store such content in electronic form. Additional terms may also apply to certain features, parts or content of the Site and, where they apply, will be displayed before you access the relevant features, parts or content.

**What you are not allowed to do**

Except to the extent expressly set out in these Terms of Service, you are not allowed to:

* store any of the Site Content on a server or other storage device connected to a network or create an electronic database by systematically downloading and storing all of the pages of the Site (other than for the purposes of search engine indexing);

* engage in spamming, flooding, harvesting of e-mail addresses or other personal information, spidering, “screen scraping,” “database scraping,” URL spoofing or any other activity with the purpose of obtaining lists of users or other information (other than for the purposes of search engine indexing);&nbsp;&nbsp;&nbsp;

* remove or change any of the Site Content or attempt to circumvent security or interfere with the proper working of the Site or the servers on which it is hosted; or&nbsp;

* create links to any Site Content or any other part of the Site that resides behind a login screen from any other website (i.e. without being prompted to enter a password), without our prior written consent, but you may link to the home page of the Site from a website that is operated by you provided the link is not misleading or deceptive and fairly indicates its destination, you do not imply that we endorse you, your website, or any products or services you offer, you link to (and do not frame or replicate) the home page of the Site, and the linked website does not contain any content that is unlawful, threatening, abusive, libellous, pornographic, obscene, vulgar, indecent, offensive or which infringes on the intellectual property rights or other rights of any third party.

You must only use the Site and anything available from the Site for lawful purposes (complying with all applicable laws and regulations), in a responsible manner, and not in a way that might damage our name or reputation or that of any of our affiliates.

You agree that you will not, nor allow anyone else to, use your account:

* to access or attempt to access any service other than your account;
* to interfere with or disrupt the provision of any of the Site’s services or use any service in a way that interferes with anyone else’s use of any service;
* to further any criminal or fraudulent activity or to impersonate another person;
* to breach the rights of any person (including, but not limited to rights of privacy and intellectual property rights); or
* otherwise in breach of any acceptable use guidelines that we may issue from time to time.

All rights granted to you under these Terms of Use will terminate immediately in the event that you are in breach of any of them.


**User-interactive features**

The Site may, from time to time, make available functionality allowing you to rate, review or comment on other users, or other user-interactive features. We do not control the input that comes from users using these features and, in particular, we do not control the ratings, reviews or comments that users give or make.&nbsp; If you use any of these features, you must comply with the User Content standards set out above.

Whilst we will attempt to remove or edit any objectionable material (including ratings, reviews and comments) brought to our attention (and which we agree is objectionable) as quickly as reasonably possible, you acknowledge that we do not generally pre-screen user input. As a result, there is always a possibility that, by using the Site, you may be exposed to content that you find objectionable, such as views about you posted by others.

**Intellectual property rights**

All intellectual property rights in any content of the Site Content (including text, graphics, software, photographs and other images, videos, sound, trade marks and logos) are owned by us or our licensors. Except as expressly set out here, nothing in these terms and conditions gives you any rights in respect of any intellectual property owned by us or our licensors and you acknowledge that you do not acquire any ownership rights by downloading content from the Site. In the event you print off, copy or store pages from the Site (only as permitted by these terms and conditions), you must ensure that any copyright, trade mark or other intellectual property right notices contained in the original content are reproduced.

Nothing in this section affects your continued ownership of intellectual property rights in any User Content you submit.

**Site Content**

We may change the format and/or functionality of the Site and Site Content from time to time. You agree that your use of the Site is on an 'as is' and 'as available' basis and at your sole risk.

We make or give no representation or warranty as to the accuracy, completeness, currency, correctness, reliability, integrity, quality, fitness for purpose or originality of any Site Content or User Content and all implied warranties, conditions or other terms of any kind are hereby excluded. To the fullest extent permitted by law, we accept no liability for any loss or damage of any kind incurred as a result of you or anyone else using the Site or relying on any of its content.

It is your responsibility to implement appropriate IT security safeguards (including anti-virus and other security checks) to satisfy your particular requirements as to the safety and reliability of the Site and its content. We are unable to guarantee that the Site or any content will be entirely virus-free.

**External links**

The Site may, from time to time, include links to external sites. We have included links to these sites to provide you with access to information and services that you may find useful or interesting. We are not responsible for the content of these sites or for anything provided by them and do not guarantee that they will be continuously available. The fact that we include links to such external sites does not imply any endorsement of or association with their operators.

**Suspension and termination**

We may, from time to time, with or without prior notice, temporarily suspend the operation of the Site (in whole or in part) for repair or maintenance work or in order to update or upgrade any contents, features or functionality.

We may, with or without prior notice, suspend or terminate any service and/or your use of your account, password and the Site in the event that you have breached these Terms of Service. We will determine, in our discretion, whether there has been a breach of these Terms of Service. When a breach of these Terms of Use has occurred, we may take such action as we deem appropriate.&nbsp; Such a breach by you may result in our taking, with or without notice, all or any of the following actions:

* issue of a warning to you;

* immediate, temporary or permanent removal of any User Content submitted by you;

* immediate, temporary or permanent withdrawal of your right to use the Site;

* legal proceedings against you for reimbursement of all loss and damage resulting from the breach; and/or

* disclosure of all relevant information to law enforcement authorities as we reasonably feel is necessary.

The responses described above are not limited, and we may take any other action we deem appropriate.

You may close your account but you must Contact us if you wish to do so.

Upon termination or closure of your account for whatever reason, all rights granted to you under these Terms of Services will immediately cease and you must promptly discontinue all use of the services offered through the Site.



**Our liability**

Nothing in these terms and conditions shall limit or exclude our liability to you:

* for death or personal injury caused by our negligence;
* for fraud or fraudulent misrepresentation; or
* for any other liability that may not, under English law, be limited or excluded.

Debate Summary is an open and collaborative platform for users to contribute freely on policy issues.&nbsp; We do not moderate contributions of users and they are not reviewed for accuracy, balance or otherwise.&nbsp;&nbsp; Whilst we hope that Debate Summary will make a constructive contribution to policy discussions, You accept that we cannot guarantee that any information or opinions will be complete, accurate or reliable.&nbsp;&nbsp; You should not make any decision of any nature solely on the basis of content available through the Site.

Subject to this, in no event shall we be liable to you for any indirect or consequential losses, or for any loss of profit, revenue, contracts, data, opportunity, goodwill or other business losses and any liability we do have for losses you suffer arising from, or in connection with, the Site and/or the services offered through the Site shall not exceed £1,000.

**Not professional advice**

Policy matters discussed in Debate Summary may have legal, tax, financial, medical or other implications on which specialist professional advice should be sought.&nbsp;&nbsp; Our contributors may not have appropriate qualifications and you should not act in reliance on what you read here, but should take your own specialist advice.

**General**

You may not transfer or assign any or all of your rights or obligations under these Terms of Service.

All notices given by you to us must be given in writing to the email address set out at the end of these terms and conditions. We may give notice to you at either the email or postal address we hold for you as updated by you in your account from time to time.

If we fail to enforce any of our rights, that does not result in a waiver of that right.

If any provision of these Terms of Use is found to be unenforceable, all other provisions shall remain unaffected.

These Terms of Use may not be varied except with our express written consent.

These Terms of Use and any document expressly referred to in them represent the entire agreement between us.

These Terms of Use shall be governed by English law, and you agree that any dispute between us regarding them or the Site or any service offered through it will only be dealt with by the English courts.


**Contact us**

Please submit any questions you have about these Terms of Use or any problems concerning the Site by email to: [hello@shouldwe.org](mailto:hello@shouldwe.org?subject=contact%20via%20debate-summary%20website).
EOF
},

  { title: 'Contact', permalink: 'contact', markdown: <<-EOF
##Contact
We'd love to hear how we can make ShouldWe better.

If you have any ideas, please send them to [hello@shouldwe.org](mailto:hello@shouldwe.org?subject=contact%20via%20debate-summary%20website).

We look forward to hearing from you!
EOF
},

  { title: 'Help us', permalink: 'help-us', markdown: <<-EOF
## Help us

As a crowd-sourced platform, ShouldWe is only as good as the help we get from people who join our movement for evidence-based policy. We’re so happy you’d like to be part of it! It’s really easy to get involved. The main ways we’ve thought of are below, but if there’s something we’ve missed let us know at [hello@shouldwe.org](mailto:hello@shouldwe.org).

**If you’ve got ....**

**No time at all right now:** please follow us on Twitter - our handle is [@ShouldWeTweets](https://twitter.com/ShouldWeTweets).

**A lot of friends:** Share the love (and the stats…). We’ve got loads of great evidence on the site, but don’t have a big budget. So please help our shoestring strategy by sharing what you like about ShouldWe. That could be our [About Us page](/about), an individual page (you’ll see a big blue "Share This" button at the top of each page) or even an individual piece of evidence (if you hover over a link you like the pop up box lets you share that one link).

**10 minutes:** Edit a page. Typos drive you crazy? You’re just our type. Got an article to hand which contains evidence that blew your mind and changed how you think about an issue? Add a link to it on the relevant ShouldWe page. At the bottom of the "Edits and Contributors" box on each page there’s a big blue "Edit this page" button. Remember to click "Save All Changes" at the bottom when you’re finished making your tweaks.

**A great network:** Is there a funder you think would love what we’re doing together? Maybe that’s you? Or perhaps you know an expert who should be creating a page, or an issue that’s bubbling up? Brilliant: let us know at [hello@shouldwe.org](mailto:hello@shouldwe.org). Maybe you’ve been looking at [#journorequest](https://twitter.com/search?q=journorequest) on twitter and know there’s someone out there researching something we’ve already covered. Awesome - let them know!

**An hour:** We *love* our page creators. If you can carve out an hour to help make evidence matter, please create a new ShouldWe page on a policy topic you think the world should be talking about. Before you start use the search box at the top of this page to check there isn’t one already. Then have a read of our “How to create a ShouldWe page” [guide](/style-guide). Then go go go! What you produce doesn’t have to be perfect, it just needs to have enough evidence on both sides that the crowd has enough to go on. Creating a ShouldWe page is a great way to showcase your expertise and our journalist friends are already excited about the site as a source for new expert commentators. So if there’s something where you know the evidence backwards, please help us to tell the people behind the headlines that you should be their guide.

**THANK YOU! We couldn’t have created ShouldWe without our creative crowd. We’re delighted you are now part of it.**
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
