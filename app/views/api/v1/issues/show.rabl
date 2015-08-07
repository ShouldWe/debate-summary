object :@issue, root: false
attributes :id, :title, :slug
node(:canonicalUrl) { |issue| issue_url(issue) }
node(:image) do |n|
  {
    pico: full_url(n.image.pico.url),
    normal: full_url(n.image.normal.url),
    thumb: full_url(n.image.thumb.url),
    original: full_url(n.image.url),
  }
end
attributes :context, :yesses, :noes, :perspectives, :relevances
child :tags do
  attributes :name
end
child :contributors do |user|
  attributes :id, :name, :bio_headline
  node :avatar do |n|
    {
      thumb: full_url(n.avatar.thumb.url),
      small: full_url(n.avatar.small.url),
      display: full_url(n.avatar.display.url),
      original: full_url(n.avatar.url),
    }
  end
end

child :last_edit_by => 'updatedBy' do
  attributes :id, :name, :bio_headline
  node :avatar do |n|
    {
      thumb: full_url(n.avatar.thumb.url),
      small: full_url(n.avatar.small.url),
      display: full_url(n.avatar.display.url),
      original: full_url(n.avatar.url),
    }
  end
end

attributes :created_at => 'createdAt', :updated_at => 'updatedAt'
