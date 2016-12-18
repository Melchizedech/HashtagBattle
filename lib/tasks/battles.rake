namespace :battles do

  desc 'Update all hashtags using random parent User'
  task :update => :environment do
    Battle.includes(:user).includes(:hashtag).order("RANDOM()").all.each do |b| 
      b.hashtags.each { |h| h.update_count(user: b.user)} 
    end
  end

  desc 'Get final yesterday count for hashtags'
  task :final_update => :environment do
    Battle.includes(:user).includes(:hashtag).order("RANDOM()").all.each do |b| 
      b.hashtags.each { |h| h.update_count(user: b.user, at: Date.yesterday.end_of_day, force: true)} 
    end
  end
end