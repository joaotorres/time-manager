# frozen_string_literal: true

module TimeSchedules
  class Manager
    def initialize(contact_center, comparison_time: Time.zone.now)
      self.comparison_time = comparison_time
      self.contact_center = contact_center
    end

    def open?
      return true if time_schedules.blank?

      time_schedules.each do |time_schedule|
        self.time_schedule = time_schedule

        return false unless time_schedule_open?

        break true
      end
    end

    def weekday_hours
      wday = contact_center.time_schedules.where(day: weekdays).first

      return 'closed' if wday.nil?

      formatted_hours(wday.period_start, wday.period_end)
    end

    def weekend_hours
      wend = contact_center.time_schedules.where(day: weekend_days).first

      return 'closed' if wend.nil?

      formatted_hours(wend.period_start, wend.period_end)
    end

    private

    attr_accessor :comparison_time, :time_schedule, :contact_center

    def time_schedules
      contact_center.time_schedules.where(day: comparison_wday)
    end

    def time_schedule_open?
      in_timezone(comparison_time).between?(period_start, period_end)
    end

    def comparison_wday
      daynames[comparison_time.wday]
    end

    def in_timezone(datetime)
      timezone = time_schedule.timezone
      datetime.in_time_zone(timezone)
    end

    def period_start
      normalize_dates(time_schedule.period_start)
    end

    def period_end
      normalize_dates(time_schedule.period_end)
    end

    def daynames
      Date::DAYNAMES
    end

    def normalize_dates(date)
      in_timezone(
        date.change(
          day: comparison_time.day,
          month: comparison_time.month,
          year: comparison_time.year
        )
      )
    end

    def weekdays
      daynames[1..5]
    end

    def weekend_days
      daynames.values_at(0, 6)
    end

    def formatted_hours(period_start, period_end)
      full_convert_to_12_clock(period_start) + '-' +
        full_convert_to_12_clock(period_end)
    end

    def full_convert_to_12_clock(time)
      Time.zone.parse("#{time.hour}:00").strftime('%l%p').delete(' ')
    end
  end
end