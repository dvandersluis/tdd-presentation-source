module RSpec
  module Rails
    module Controller
      module LoginAs
        def login_as(type, options = {})
          if options[:client]
            @client = options[:client]
          elsif self.current_client
            @client = self.current_client
          end
          
          if @client
            if ClientStructureTree.where{ client_id == my{ @client.id } }.exists?
              @client_structure_tree = ClientStructureTree.where{ client_id == my{ @client.id } }.first
            else
              @client_structure_tree = ClientStructureTree.make!(:client => @client)
            end
          else
            @client_structure_tree = ClientStructureTree.make!
            @client = @client_structure_tree.client
          end
          
          if type == :candidate
            user = CandidateUser.make
            user.skip_location_validation!
            user.save!
            session[:candidate_user_id] = user.id
          elsif type == :employee
            employee = Employee.make!(:client => @client, :client_structure_tree => @client_structure_tree)
            user = employee.candidate_user
            session[:candidate_user_id] = employee.candidate_user_id
          else
            user = ClientUser.make!(type.to_sym, :client => @client)
            session[:user_id] = user.id
            self.request.stub(:subdomain) { "clients" }
          end
          
          self.stub(:current_client) { @client }
          self.stub(:current_user) { user }
        end
      end
    end
  end
end

ApplicationController.send(:include, RSpec::Rails::Controller::LoginAs)