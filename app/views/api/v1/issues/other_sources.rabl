collection :@news, root: false, object_root: false
node('title') {|n| n['Title'] }
node('content') {|n| n['Description'] }
node('href') {|n| n['Url'] }
node('updatedAt') {|n| n['Date'] }
node('source') {|n| n['Source'] }
