node.reverse_merge!(
  rbenv: {
    user: 'kenchan',
    versions: %w[
      2.6.1
    ]
  }
)

include_recipe 'rbenv::user'
