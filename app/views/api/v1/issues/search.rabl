child :@issues do |issue|
  attributes :id, :title
  node(:canonicalUrl) { |issue| issue_url(issue) }
  node(:image) do |n|
    {
      pico: full_url(n.image.pico.url),
      normal: full_url(n.image.normal.url),
      thumb: full_url(n.image.thumb.url),
      original: full_url(n.image.url),
    }
  end
end

child :@meta do |meta|
  attributes :totalResults, :limit, :offset, :query
end
