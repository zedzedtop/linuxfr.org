namespace :linuxfr do
  desc "Daily crontab"
  task :daily => [
    :flush_poll_ips,
    :delete_old_passive_accounts,
    :delete_old_boards,
    :delete_old_votes,
    'sitemap:refresh',
    'friendly_id:remove_old_slugs'
  ]

  desc "New day => the users can revote on polls"
  task :flush_poll_ips => :environment do
    PollIp.delete_all
  end

  desc "Delete old accounts that were never activated"
  task :delete_old_passive_accounts => :environment do
    Account.passive.delete_all(["created_at <= ?", DateTime.now - 2.days])
  end

  desc "Delete old messages in the boards"
  task :delete_old_boards => :environment do
    Board.old.delete_all
  end

  desc "Delete old votes on contents and comments (users cannot vote on them)"
  task :delete_old_votes => :environment do
    Vote.old.delete_all
    Relevance.old.delete_all
  end
end
