module ItsBusinessTime
  module TimeExtensions
    # True if this time is on a workday (between 00:00:00 and 23:59:59), even if
    # this time falls outside of normal business hours.
    def workday?
      weekday? && !holiday?
    end

    # True if this time falls on a weekday.
    def weekday?
      ItsBusinessTime.configuration.work_week.include?(tz_adjusted.wday)
    end

    # True if this time falls on a configured holiday.
    def holiday?
      ItsBusinessTime.configuration.holidays.include?(tz_adjusted.to_date)
    end

    def during_business_hours?
      workday? && to_i.between?(beginning_of_workday.to_i, end_of_workday.to_i)
    end

    def beginning_of_workday
      bowd = ItsBusinessTime.configuration.beginning_of_workday(tz_adjusted)

      tz_adjusted.change(hour: bowd.hour, min: bowd.min, sec: bowd.sec)
    end

    def end_of_workday
      eowd = ItsBusinessTime.configuration.end_of_workday(tz_adjusted)

      tz_adjusted.change(hour: eowd.hour, min: eowd.min, sec: eowd.sec)
    end

    def next_beginning_of_workday(time = tz_adjusted)
      return next_beginning_of_workday(time + 1.day) unless time.workday?

      time.beginning_of_workday
    end

    private

    def tz_adjusted
      in_time_zone(ItsBusinessTime.configuration.time_zone)
    end
  end
end
