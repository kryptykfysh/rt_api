# encoding: utf-8

require 'spec_helper'
require 'yaml'

module RTApi
  RSpec.describe Ticket do
    let(:ticket) { RTApi::Ticket.new(1) }
    subject { ticket }

    describe 'attributes' do
      specify { should respond_to :admin_cc         }
      specify { should respond_to :cached_history   }
      specify { should respond_to :cc               }
      specify { should respond_to :created          }
      specify { should respond_to :creator          }
      specify { should respond_to :custom_fields    }
      specify { should respond_to :due              }
      specify { should respond_to :id               }
      specify { should respond_to :final_priority   }
      specify { should respond_to :initial_priority }
      specify { should respond_to :last_updated     }
      specify { should respond_to :priority         }
      specify { should respond_to :queue            }
      specify { should respond_to :requestors       }
      specify { should respond_to :resolved         }
      specify { should respond_to :started          }
      specify { should respond_to :starts           }
      specify { should respond_to :status           }
      specify { should respond_to :subject          }
      specify { should respond_to :time_estimated   }
      specify { should respond_to :time_left        }
      specify { should respond_to :time_worked      }
      specify { should respond_to :told             }
    end

    describe 'methods' do
      describe 'class methods' do
        describe '::new' do
          it 'requires a ticket_id argument' do
            expect{RTApi::Ticket.new}.to raise_error(ArgumentError)
          end

          it 'should set @id to the value of the ticket_id argument' do
            ticket_id = 42
            ticket = Ticket.new(ticket_id)
            expect(ticket.id).to eq(ticket_id)
          end

          it 'should set @id to an integer, if conversion required' do
            ticket_id = '69'
            ticket = Ticket.new(ticket_id)
            expect(ticket.id).to be_an_instance_of(Fixnum)
            expect(ticket.id).to eq(69)
          end
        end
      end

      describe 'instance_methods' do
        specify { should respond_to :history        }
        specify { should respond_to :set_basic_data }
        specify { should respond_to :set_history    }

        describe '#history' do
          context 'when @cached_history is empty' do
            before { allow(ticket.cached_history).to receive(:empty?).and_return(true) }

            it 'should return an empty Array' do
              expect(ticket.history).to eq([])
            end
          end

          context 'when @cached_history is not empty' do
            before do
              ticket.instance_variable_set('@cached_history', 'wibble')
            end

            it 'should return @cached_history' do
              expect(ticket.history).to eq('wibble')
            end
          end
        end

        describe '#set_basic_data' do
          it 'should require a string argument' do
            expect{ticket.set_basic_data}.to raise_error(ArgumentError)
          end

          context 'with a valid data_string argument' do
            let(:data_string) { "RT/3.8.2 200 Ok\n\nid: ticket/5509855\nQueue: Technology\nOwner: b.wherry\nCreator: a.curin\nSubject: SSL Pricing Description in VAR Stores - SEV3\nStatus: stalled\nPriority: 75\nInitialPriority: 75\nFinalPriority: 0\nRequestors: a.curin@uber.com.au\nCc:\nAdminCc:\nCreated: Tue Mar 25 16:42:44 2014\nStarts: Not set\nStarted: Thu Mar 27 11:47:12 2014\nDue: Not set\nResolved: Not set\nTold: Fri Apr 11 12:38:24 2014\nLastUpdated: Fri Apr 11 12:38:24 2014\nTimeEstimated: 0\nTimeWorked: 0\nTimeLeft: 0\nCF.{Subscription ID}: 987654321\nCF.{Classification}: \nCF.{Customer ID}: 123456789\n\n" }
            it 'should set @queue' do
              expect{ticket.set_basic_data(data_string)}
                .to change{ticket.queue}.from(nil).to('Technology')
            end
          end
        end

        describe '#set_history' do
          it 'requires a raw String argument' do
            expect{ticket.set_history}.to raise_error(ArgumentError)
          end

          context 'with a valid String argument' do
            let(:raw_string) { File.read(File.join(File.dirname(__FILE__), 'history_string.txt')) }

            before { allow(ticket).to receive(:parse_history_string).and_return([{ id: 3 }, { id: '42' }]) }

            it 'should call #parse_history_string' do
              expect(ticket).to receive(:parse_history_string).with(raw_string)
              ticket.set_history(raw_string)
            end

            it 'should populate @cached_history' do
              expect{ticket.set_history(raw_string)}.to change{ticket.cached_history}.from([])
            end
          end
        end
      end

      describe 'private instance methods' do
        specify { should_not respond_to :parse_basic_data_string  }
        specify { should_not respond_to :parse_history_string     }

        describe '#parse_basic_data_string' do
          let(:raw_string) do
            "RT/3.8.2 200 Ok\n\nid: ticket/5850276\nQueue: Solutions\nOwner: n.collins\nCreator: steve.moran@grays.com.au\nSubject: Extra Disk Space required for CBR-OO-SPC01\nStatus: open\nPriority: 9000\nInitialPriority: 9000\nFinalPriority: 9000\nRequestors: steve.moran@grays.com.au\nCc:\nAdminCc: n.collins@uber.com.au, n.steenland@uber.com.au,\n b.wherry@uber.com.au\nCreated: Fri Dec 26 22:45:36 2014\nStarts: Not set\nStarted: Fri Dec 26 23:02:23 2014\nDue: Not set\nResolved: Not set\nTold: Mon Dec 29 15:32:17 2014\nLastUpdated: Wed Jan 07 15:32:43 2015\nTimeEstimated: 0\nTimeWorked: 0\nTimeLeft: 0\nCF.{Subscription ID}: \nCF.{Classification}: \nCF.{Customer ID}: \n\n"
          end

          it "should merge multiline values that don't match regex value" do
            expect(ticket.send(:parse_basic_data_string, raw_string))
              .to eq(YAML.load("---\n:queue: Solutions\n:owner: n.collins\n:creator: steve.moran@grays.com.au\n:subject: 2015-01-01 00:00:00.000000000 +11:00\n:status: open\n:priority: 9000\n:initial_priority: 9000\n:final_priority: 9000\n:requestors: steve.moran@grays.com.au\n:cc: \n:admin_cc: |-\n  n.collins@uber.com.au, n.steenland@uber.com.au,\n   b.wherry@uber.com.au\n:created: 2014-12-26 22:45:36.000000000 +11:00\n:starts: \n:started: 2014-12-26 23:02:23.000000000 +11:00\n:due: \n:resolved: \n:told: 2014-12-29 15:32:17.000000000 +11:00\n:last_updated: 2015-01-07 15:32:43.000000000 +11:00\n:time_estimated: 0\n:time_worked: 0\n:time_left: 0\n:custom_fields:\n  :subscription_id: \n  :classification: \n  :customer_id: \n"))
          end
        end

        describe ':parse_history_string' do
          it 'requires a String argument' do
            expect{ticket.send(:parse_history_string)}.to raise_error(ArgumentError)
          end

          context 'with a valid String argument' do
            let(:raw_string) { File.read(File.join(File.dirname(__FILE__), 'history_string.txt')) }

            it 'should split the string in to histories on "\n--\n"' do
              expect(ticket.send(:parse_history_string, raw_string).size)
                .to eq(raw_string.split("\n--\n").size)
            end

            it 'should return an Array of Hashes' do
              expect(ticket.send(:parse_history_string, raw_string))
                .to eq(YAML.load_file(File.join(File.dirname(__FILE__), 'parsed_history.yml')))
            end
          end
        end
      end
    end
  end
end

