# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeSchedules::Manager do
  describe '#open?' do
    context 'is in opening hours' do
      context 'with only one time_schedule available' do
        it 'returns true' do
          contact_center = create(:contact_center)

          Timecop.freeze(any_given_sunday) do
            create(
              :time_schedule,
              day: 'Sunday',
              period_start: 1.hour.ago,
              period_end: 2.hours.from_now
            )

            manager = described_class.new(comparison_time: Time.zone.now)

            expect(manager).to be_open
          end
        end
      end

      context 'with time_schedules in different time_zones' do
        it 'returns true' do
          contact_center = create(:contact_center)

          Timecop.freeze(any_given_sunday) do
            create(
              :time_schedule,
              day: 'Monday',
              period_start: 1.hour.ago,
              period_end: 2.hours.from_now
            )

            create(
              :time_schedule,
              :spain,
              day: 'Sunday',
              period_start: 1.hour.ago,
              period_end: 2.hours.from_now
            )

            manager = described_class.new(comparison_time: Time.zone.now)

            expect(manager).to be_open
          end
        end
      end
    end

    context 'is outside of opening hours' do
      it 'returns false' do
        contact_center = create(:contact_center)

        Timecop.freeze(any_given_sunday) do
          create(
            :time_schedule,
            day: 'Sunday',
            period_start: 1.hour.from_now,
            period_end: 2.hours.from_now
          )

          manager = described_class.new(comparison_time: Time.zone.now)

          expect(manager).to_not be_open
        end
      end
    end

    context 'no time schedule is set for the comparison day' do
      it 'returns true' do
        Timecop.freeze(any_given_sunday) do
          manager = described_class.new(comparison_time: Time.zone.now)

          expect(manager).to be_open
        end
      end
    end
  end

  describe '#weekday_hours' do
    it 'returns the hours of the first weekend' do
      contact_center = create(:contact_center)

      Timecop.freeze(any_given_sunday) do
        create(
          :time_schedule,
          day: 'Monday',
          period_start: 1.hour.ago,
          period_end: 2.hours.from_now
        )

        manager = described_class.new(comparison_time: Time.zone.now)

        expected = '1PM-4PM'
        expect(manager.weekday_hours).to eq(expected)
      end
    end

    context 'no weekday hours' do
      it 'returns closed' do
        Timecop.freeze(any_given_sunday) do
          manager = described_class.new(comparison_time: Time.zone.now)

          expected = 'closed'
          expect(manager.weekday_hours).to eq(expected)
        end
      end
    end
  end

  describe '#weekend_hours' do
    it 'returns the hours of the first weekday' do
      contact_center = create(:contact_center)

      Timecop.freeze(any_given_sunday) do
        create(
          :time_schedule,
          day: 'Sunday',
          period_start: 2.hours.ago,
          period_end: 3.hours.from_now
        )

        manager = described_class.new(comparison_time: Time.zone.now)

        expected = '12PM-5PM'
        expect(manager.weekend_hours).to eq(expected)
      end
    end

    context 'no weekend hours' do
      it 'returns closed' do
        Timecop.freeze(any_given_sunday) do
          manager = described_class.new(comparison_time: Time.zone.now)

          expected = 'closed'
          expect(manager.weekend_hours).to eq(expected)
        end
      end
    end
  end

  def any_given_sunday
    Time.zone.local('2018', '08', '19', '14', '00')
  end

  def formatted_time(time)
    time.strftime('%H:%M')
  end
end