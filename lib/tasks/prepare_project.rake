desc 'This rebuilds development db'
task prepare_project: %w[db:create db:migrate db:seed]
task rebuild_project: %w[db:drop db:create db:migrate db:seed]
