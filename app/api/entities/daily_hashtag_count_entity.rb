module Entities
  class DailyHashtagCountEntity < Grape::Entity
    expose :count, documentation: { type: Integer, desc: 'ID of the Count'}
    expose :at, documentation: { type: Date, desc: 'Counting for the date'} do |dhc, attribute|
      dhc.last_refresh.to_date
    end
  end
end