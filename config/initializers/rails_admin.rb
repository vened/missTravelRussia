RailsAdmin.config do |config|

  config.parent_controller = '::ApplicationController'
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  config.authorize_with :pundit
  config.current_user_method(&:current_user)

  # config.attr_accessible_role { :admin }

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    list do
      field :number
      field :name
      field :age
      field :organization
      field :phone
      field :email
      field :email2
      field :gender
      field :created_at
      field :updated_at
    end
  end

end
