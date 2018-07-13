require 'active_support/core_ext'

module ItsBusinessTime

  class Config

    attr_accessor :holidays

    attr_reader :time_zone

    attr_reader :work_hours

    def initialize
      self.holidays = SortedSet.new
      self.time_zone = 'UTC'
      self.work_hours = {
        mon: ['9:00 am', '5:00 pm'],
        tue: ['9:00 am', '5:00 pm'],
        wed: ['9:00 am', '5:00 pm'],
        thu: ['9:00 am', '5:00 pm'],
        fri: ['9:00 am', '5:00 pm']
      }
    end

    def work_week
      @week ||= SortedSet.new(work_hours.keys.map { |day| wday_to_int(day) })
    end

    def beginning_of_workday(time)
      work_hours[int_to_wday(time.wday)].first
    end

    def end_of_workday(time)
      work_hours[int_to_wday(time.wday)].last
    end

    def work_hours=(work_hrs)
      @week = nil
      @work_hours = {}
      work_hrs.each do |dow, times|
        @work_hours[dow] = times.map { |time| ItsBusinessTime::ParsedTime.parse(time) }
      end
    end

    def time_zone=(zone_name)
      @time_zone = Time.find_zone!(zone_name)
    end

    private

    def wday_to_int day_name
      lowercase_day_names = ::Time::RFC2822_DAY_NAME.map(&:downcase)
      lowercase_day_names.find_index(day_name.to_s.downcase)
    end

    def int_to_wday num
      ::Time::RFC2822_DAY_NAME.map(&:downcase).map(&:to_sym)[num]
    end
  end
end
