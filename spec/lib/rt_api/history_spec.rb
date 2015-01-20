# encoding: utf-8

require 'spec_helper'

module RTApi
  RSpec.describe History do
    let(:history) { RTApi::History.new }
    subject { history }

    describe 'attributes' do
      specify { expect(history).to respond_to :id           }
      specify { expect(history).to respond_to :ticket_id    }
      specify { expect(history).to respond_to :time_taken   }
      specify { expect(history).to respond_to :type         }
      specify { expect(history).to respond_to :field        }
      specify { expect(history).to respond_to :old_value    }
      specify { expect(history).to respond_to :new_value    }
      specify { expect(history).to respond_to :data         }
      specify { expect(history).to respond_to :description  }
      specify { expect(history).to respond_to :content      }
      specify { expect(history).to respond_to :creator      }
      specify { expect(history).to respond_to :created_at   }
      specify { expect(history).to respond_to :attachments  }
    end

    describe 'methods' do
      describe 'class methods' do
        describe '::new' do
          it 'accepts an optional options hash' do
            expect{RTApi::History.new}.to_not raise_error
          end

          it 'should parse options[:created_at] to a Time' do
            options = { created_at: '2014-03-27 00:47:12' }
            new_hist = RTApi::History.new(options)
            expect(new_hist.created_at).to eq(Time.parse(options[:created_at]))
          end

          it 'should parse options[:id] to a Fixnum' do
            options = { id: '42' }
            new_hist = RTApi::History.new(options)
            expect(new_hist.id).to eq(options[:id].to_i)
          end

          it 'should parse options[:ticket_id] to a Fixnum' do
            options = { ticket_id: '42' }
            new_hist = RTApi::History.new(options)
            expect(new_hist.ticket_id).to eq(options[:ticket_id].to_i)
          end

          it 'should parse options[:time_taken] to a Fixnum' do
            options = { time_taken: '42' }
            new_hist = RTApi::History.new(options)
            expect(new_hist.time_taken).to eq(options[:time_taken].to_i)
          end

          it 'should parse other options keys to string attributes' do
            options = { badger: 'hatstand' }
            new_hist = RTApi::History.new(options)
            expect(new_hist.instance_variable_get('@badger')).to eq('hatstand')
          end
        end
      end
    end
  end
end
