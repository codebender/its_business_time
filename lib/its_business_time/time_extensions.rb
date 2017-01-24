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

    def next_beginning_of_workday
      return tz_adjusted.beginning_of_workday if before_business_hours?

      next_business_day = after_business_hours? ? tz_adjusted.clone + 1.day : tz_adjusted.clone
      while !next_business_day.workday? do
        next_business_day += 1.day
      end

      return next_business_day.beginning_of_workday
    end

    private

    def tz_adjusted
      @in_tz ||= in_time_zone(ItsBusinessTime.configuration.time_zone)
    end

    def before_business_hours?
      workday? && to_i < beginning_of_workday.to_i
    end

    def after_business_hours?
      workday? && to_i > end_of_workday.to_i
    end
  end
end
