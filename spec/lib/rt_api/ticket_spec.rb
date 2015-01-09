# encoding: utf-8

require 'spec_helper'

module RTApi
  RSpec.describe Ticket do
    let(:ticket) { RTApi::Ticket.new(1) }
    subject { ticket }

    describe 'attributes' do
      specify { should respond_to :admin_cc         }
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
        specify { should respond_to :parse_basic_ticket_data }

        describe '#parse_basic_ticket_data' do
          let(:data_string) { "RT/3.8.2 200 Ok\n\nid: ticket/5509855\nQueue: Technology\nOwner: b.wherry\nCreator: a.curin\nSubject: SSL Pricing Description in VAR Stores - SEV3\nStatus: stalled\nPriority: 75\nInitialPriority: 75\nFinalPriority: 0\nRequestors: a.curin@uber.com.au\nCc:\nAdminCc:\nCreated: Tue Mar 25 16:42:44 2014\nStarts: Not set\nStarted: Thu Mar 27 11:47:12 2014\nDue: Not set\nResolved: Not set\nTold: Fri Apr 11 12:38:24 2014\nLastUpdated: Fri Apr 11 12:38:24 2014\nTimeEstimated: 0\nTimeWorked: 0\nTimeLeft: 0\nCF.{Subscription ID}: \nCF.{Classification}: \nCF.{Customer ID}: \n\n" }
          it 'should require a string argument' do
            expect{ticket.parse_basic_ticket_data}.to raise_error(ArgumentError)
          end

          context 'with a valid data_string argument' do

            it 'should set @queue' do
              expect{ticket.parse_basic_ticket_data(data_string)}
                .to change{ticket.queue}.from(nil).to('Technology')
            end
          end
        end
      end
    end
  end
end

