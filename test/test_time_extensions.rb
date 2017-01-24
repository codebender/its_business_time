require File.expand_path('../helper', __FILE__)

describe "time extensions" do
  it "know a weekend day is not a workday" do
    assert( Time.parse("April 9, 2010 10:45 am UTC").workday?)
    refute( Time.parse("April 10, 2010 10:45 am UTC").workday?)
    refute( Time.parse("April 11, 2010 10:45 am UTC").workday?)
    assert( Time.parse("April 12, 2010 10:45 am UTC").workday?)
  end

  it "know a weekend day is not a workday (with a configured work week)" do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        sun: ['9:00 am', '5:00 pm'],
        mon: ['9:00 am', '5:00 pm'],
        tue: ['9:00 am', '5:00 pm'],
        wed: ['9:00 am', '5:00 pm'],
        thu: ['9:00 am', '5:00 pm']
      }
    end

    assert( Time.parse("April 8, 2010 10:30am UTC").weekday?)
    refute( Time.parse("April 9, 2010 10:30am UTC").weekday?)
    refute( Time.parse("April 10, 2010 10:30am UTC").weekday?)
    assert( Time.parse("April 11, 2010 10:30am UTC").weekday?)
  end

  it "knows that a holiday is not a workday" do
    ItsBusinessTime.configure do |c|
      c.holidays = [Date.parse("July 4, 2010"), Date.parse("July 5, 2010")]
    end

    refute( Time.parse("July 4th, 2010 1:15 pm UTC").workday?)
    refute( Time.parse("July 5th, 2010 2:37 pm UTC").workday?)
  end

  it 'knows which holidays are configured' do
    refute(Time.parse("July 4th, 2010 1:15 pm UTC").holiday?)

    ItsBusinessTime.configure do |c|
      c.holidays << Date.parse("July 4, 2010 UTC")
    end

    assert(Time.parse("July 4th, 2010 1:15 pm UTC").holiday?)
  end

  it "determines if a time is during business hours" do
    assert(Time.parse("2013-02-01 10:00 UTC").during_business_hours?)
    refute(Time.parse("2013-02-01 5:00 UTC").during_business_hours?)
  end

  it "determines the the beginning of a workday " do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        tue: ['9:00 am', '5:00 pm'],
        wed: ['5:00 am', '7:00 pm'],
        thu: ['9:00 am', '5:00 pm']
      }
    end

    first = Time.parse("January 18th, 2017, 11:50 am UTC")
    expecting = Time.parse("January 18th, 2017, 5:00 am UTC")
    assert_equal expecting, first.beginning_of_workday
  end

  it "calculates the the end of a workday" do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        tue: ['9:00 am', '5:00 pm'],
        wed: ['5:00 am', '7:00 pm'],
        thu: ['9:00 am', '5:00 pm']
      }
    end

    first = Time.parse("January 18th, 2017, 11:50 am UTC")
    expecting = Time.parse("January 18th, 2017, 7:00 pm UTC")
    assert_equal expecting, first.end_of_workday
  end

  it 'calculates the next beginning of a work day, when not a work day' do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        tue: ['9:00 am', '5:00 pm'],
        wed: ['5:00 am', '7:00 pm'],
        thu: ['9:00 am', '5:00 pm']
      }
    end

    current_time = Time.parse("2017-01-21 5:00 am UTC")

    refute(current_time.during_business_hours?)

    expecting = Time.parse("January 24th, 2017, 9:00 am UTC")
    assert_equal expecting, current_time.next_beginning_of_workday
  end

  it 'calculates the next beginning of a work day, when before hours on a work day' do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        tue: ['9:00 am', '5:00 pm'],
        wed: ['5:00 am', '7:00 pm'],
        thu: ['9:00 am', '5:00 pm']
      }
    end

    current_time = Time.parse("2017-01-24 6:00 am UTC")

    refute(current_time.during_business_hours?)

    expecting = Time.parse("January 24th, 2017, 9:00 am UTC")
    assert_equal expecting, current_time.next_beginning_of_workday
  end

  it 'calculates the next beginning of a work day, when after hours on a work day' do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        tue: ['9:00 am', '5:00 pm'],
        wed: ['5:00 am', '7:00 pm'],
        thu: ['9:00 am', '5:00 pm']
      }
    end

    current_time = Time.parse("2017-01-24 6:00 pm UTC")

    refute(current_time.during_business_hours?)

    expecting = Time.parse("January 25th, 2017, 5:00 am UTC")
    assert_equal expecting, current_time.next_beginning_of_workday
  end

  describe 'configured as Eastern Timezone' do
    before(:each) do
      ItsBusinessTime.configure do |c|
        c.time_zone = 'Eastern Time (US & Canada)'
      end
    end

    it "know a weekend day is not a workday" do
      assert( Time.parse("April 10, 2010 3:45 am UTC").workday?)
      refute( Time.parse("April 11, 2010 3:45 am UTC").workday?)
      refute( Time.parse("April 12, 2010 3:45 am UTC").workday?)
      assert( Time.parse("April 13, 2010 3:45 am UTC").workday?)
    end

    it "know a weekend day is not a workday (with a configured work week)" do
      assert( Time.parse("2017-01-21 3:30am UTC").weekday?)
      refute( Time.parse("2017-01-22 3:30am UTC").weekday?)
      refute( Time.parse("2017-01-23 3:30am UTC").weekday?)
      assert( Time.parse("2017-01-24 3:30am UTC").weekday?)
    end

    it "determines if a time is during business hours" do
      refute(Time.parse("2017-01-23 10:00 UTC").during_business_hours?)
      refute(Time.parse("2013-01-23 5:00 UTC").during_business_hours?)
      assert(Time.parse("2017-01-23 10:00 EST").during_business_hours?)
      refute(Time.parse("2013-01-23 5:00 EST").during_business_hours?)
    end

    it "determines the the beginning of a workday " do
      ItsBusinessTime.configure do |c|
        c.work_hours = {
          tue: ['9:00 am', '5:00 pm'],
          wed: ['5:00 am', '7:00 pm'],
          thu: ['9:00 am', '5:00 pm']
        }
      end

      now = Time.parse("January 18th, 2017, 11:50 am UTC")
      expecting = Time.parse("January 18th, 2017, 5:00 am EST")
      assert_equal expecting, now.beginning_of_workday
    end

    it "calculates the the end of a workday" do
      ItsBusinessTime.configure do |c|
        c.work_hours = {
          tue: ['9:00 am', '5:00 pm'],
          wed: ['5:00 am', '7:00 pm'],
          thu: ['9:00 am', '5:00 pm']
        }
      end

      now = Time.parse("January 18th, 2017, 11:50 am UTC")
      expecting = Time.parse("January 18th, 2017, 7:00 pm EST")
      assert_equal expecting, now.end_of_workday
    end
  end
end
