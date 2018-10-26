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
    dropzone do
      only Gallery
    end

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

  config.model User do
    configure :age, :string
    configure :email2, :string
    configure :phone, :string
    configure :organization, :string
    configure :organization_site, :string
    configure :work_experience, :string
    configure :position, :string
    configure :location, :string
  end

  config.model Gallery do
    configure :title, :string
    configure :description, :string
    configure :title_seo, :string
    configure :description_seo, :string
    configure :show_home, :boolean
    configure :show_menu, :boolean
  end

end
