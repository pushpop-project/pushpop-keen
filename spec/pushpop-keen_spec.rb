require 'spec_helper'

describe Pushpop::Keen do

  describe '#configure' do

    it 'sets various params' do

      step = Pushpop::Keen.new do
        event_collection 'pageviews'
        analysis_type 'count'
        timeframe 'last_3_days'
        target_property 'trinkets'
        group_by 'referer'
        interval 'hourly'
        max_age '300'
        filters [{ property_value: 'referer',
                   operator: 'ne',
                   property_value: 'yahoo.com' }]
        steps [{ event_collection: 'pageviews',
                 actor_property: 'user.id' }]
        analyses [{ analysis_type: 'count' }]
      end

      step.configure

      expect(step._event_collection).to eq('pageviews')
      expect(step._analysis_type).to eq('count')
      expect(step._timeframe).to eq('last_3_days')
      expect(step._group_by).to eq('referer')
      expect(step._interval).to eq('hourly')
      expect(step._max_age).to eq('300')
      expect(step._steps).to eq([{
         event_collection: 'pageviews',
         actor_property: 'user.id'
        }])
      expect(step._analyses).to eq([{ analysis_type: 'count' }])
    end

  end

  describe '#record' do
    it 'records an event with properties' do
      step = Pushpop::Keen.new do
        record 'Pageview', useragent: 'Chrome'
      end

      expect(Keen).to receive(:publish).with('Pageview', useragent: 'Chrome')
      step.run
    end
  end

  describe '#run' do
    it 'runs the query based on the analysis type' do
      allow(Keen).to receive(:count) { 365 }
      #Keen.stub(:count).with('pageviews', {
      #    timeframe: 'last_3_days'
      #}).and_return(365)

      step = Pushpop::Keen.new('one') do
        event_collection 'pageviews'
        analysis_type 'count'
        timeframe 'last_3_days'
      end

      response = step.run
      expect(response).to eq(365)
    end

    it 'don\'t run a query if the analysis type isnt set' do
      step = Pushpop::Keen.new do
        group_by 'something'
      end

      expect(Keen).not_to receive(:send)
      expect(Keen).not_to receive(:funnel)

      step.run
    end

    it 'run funnels directly, instead of using send' do
      step = Pushpop::Keen.new('one') do
        analysis_type 'funnel'
        steps [
          {
            actor_property: 'uuid',
            event_collection: 'pageviews',
            timeframe: 'this_3_days'
          },
          {  
            actor_property: 'uuid',
            event_collection: 'link_clicks',
            timeframe: 'this_3_days'
          }
        ]
      end

      expect(Keen).to receive(:funnel)
      expect(Keen).not_to receive(:send)

      step.run
    end
  end

  describe '#to_analysis_options' do
    it 'includes various options' do
      step = Pushpop::Keen.new('one') do end
      step._timeframe = 'last_4_days'
      step._group_by = 'referer'
      step._target_property = 'trinkets'
      step._interval = 'hourly'
      step._filters = [{ property_value: 'referer',
                         operator: 'ne',
                         property_value: 'yahoo.com' }]
      step._steps = [{ event_collection: 'pageviews',
                       actor_property: 'user.id' }]
      step._analyses = [{ analysis_type: 'count' }]

      expect(step.to_analysis_options).to eq({
          timeframe: 'last_4_days',
          target_property: 'trinkets',
          group_by: 'referer',
          interval: 'hourly',
          filters: [{ property_value: 'referer',
                         operator: 'ne',
                         property_value: 'yahoo.com' }],
          steps: [{ event_collection: 'pageviews',
                       actor_property: 'user.id' }],
          analyses: [{ analysis_type: 'count' }]
      })
    end

    it 'doesn\'t include nils' do
      step = Pushpop::Keen.new('one') do end
      expect(step.to_analysis_options).to eq({})
    end
  end
end
