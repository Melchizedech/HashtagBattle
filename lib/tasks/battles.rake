namespace :battles do

  desc 'Update all hashtags using random parent User'
  task :update => :environment do
    Battle.includes(:user, :hashtags).order("RANDOM()").all.each { |b| b.upate_hashtags}
  end

  desc 'Get final yesterday count for hashtags'
  task :final_update => :environment do
    Battle.includes(:user, :hashtags).order("RANDOM()").all.each { |b| b.upate_hashtags(at: Date.yesterday.end_of_day) }
  end
end