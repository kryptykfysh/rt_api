# encoding: utf-8

require 'spec_helper'

module RTApi
  RSpec.describe Session do
    before do
      allow_any_instance_of(RTApi::Connection).to receive(:valid?).and_return(true)
      allow_any_instance_of(RTApi::Connection).to receive(:full_path).and_return('')
    end

    let(:session) { RTApi::Session.new }

    describe 'attributes' do
      specify { should respond_to :connection     }
      specify { should respond_to :current_ticket }
    end

    describe 'methods' do
      describe 'instance method list' do
        before do
          allow_any_instance_of(RTApi::Connection).to receive(:valid?).and_return(true)
        end

        let(:session) {RTApi::Session.new }

        specify { should respond_to :get_ticket             }
        specify { should respond_to :set_basic_ticket_data  }
      end

      describe '::new' do
        it 'should set @connection to an instance of RTApi::Connection' do
          expect(session.connection).to be_an_instance_of(RTApi::Connection)
        end

        context 'with invalid connection information' do
          before do
            allow_any_instance_of(RTApi::Connection).to receive(:valid?).and_return(false)
          end

          it 'should throw an RTApi::ConnectionError' do
            expect{RTApi::Session.new}.to raise_error(RTApi::ConnectionError)
          end
        end
      end

      describe '#get_ticket' do
        it 'requires a ticket_id argument' do
          expect{session.get_ticket}.to raise_error(ArgumentError)
        end

        context 'with a valid ticket_id argument' do
          before { allow(session).to receive(:set_basic_ticket_data).and_return('') }

          let(:ticket_id) { 1234 }

          it 'should return an instance of RTApi::Ticket' do
            expect(session.get_ticket(ticket_id)).to be_an_instance_of(RTApi::Ticket)
          end

          it 'should set session.current_ticket to the ticket value' do
            expect{session.get_ticket(ticket_id)}.to change{session.current_ticket}.from(nil)
          end

          it 'should call #set_basic_data' do
            expect(session).to receive(:set_basic_ticket_data)
            session.get_ticket(ticket_id)
          end
        end
      end

      describe '#set_basic_ticket_data' do
        before do
          allow(session.connection).to receive(:full_path).and_return('')
          allow(session.current_ticket).to receive(:parse_basic_ticket_data).and_return('')
          session.instance_variable_set('@current_ticket', RTApi::Ticket.new(1234))
        end

        context 'with a valid RestClient response' do
          before do
            allow_any_instance_of(RestClient::Request).to receive(:execute).and_return("RT/3.8.2 200 Ok\n\nid: ticket/5509855\nQueue: Technology\nOwner: b.wherry\nCreator: a.curin\nSubject: SSL Pricing Description in VAR Stores - SEV3\nStatus: stalled\nPriority: 75\nInitialPriority: 75\nFinalPriority: 0\nRequestors: a.curin@uber.com.au\nCc:\nAdminCc:\nCreated: Tue Mar 25 16:42:44 2014\nStarts: Not set\nStarted: Thu Mar 27 11:47:12 2014\nDue: Not set\nResolved: Not set\nTold: Fri Apr 11 12:38:24 2014\nLastUpdated: Fri Apr 11 12:38:24 2014\nTimeEstimated: 0\nTimeWorked: 0\nTimeLeft: 0\nCF.{Subscription ID}: \nCF.{Classification}: \nCF.{Customer ID}: \n\n")
          end

          it 'should return the updated RTApi::Ticket' do
            expect(session.set_basic_ticket_data).to be_an_instance_of(RTApi::Ticket)
          end
        end
      end
    end
  end
end
