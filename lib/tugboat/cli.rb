require 'thor'

module Tugboat
  autoload :Middleware, "tugboat/middleware"

  class CLI < Thor
    include Thor::Actions
    ENV['THOR_COLUMNS'] = '120'

    !check_unknown_options

    desc "help [COMMAND]", "Describe commands or a specific command"
    def help(meth=nil)
      super
      if !meth
        say "To learn more or to contribute, please see github.com/pearkes/tugboat"
      end
    end

    desc "authorize", "Authorize a DigitalOcean account with tugboat"
    long_desc "This takes you through a workflow for adding configuration
    details to tugboat. First, you are asked for your API and Client keys,
    which are stored in ~/.tugboat.

    You can retrieve your credentials from digitalocean.com/api_access.

    Optionally, you can configure the default SSH key path and username
    used for `tugboat ssh`. These default to '~/.ssh/id_rsa' and the
    $USER environment variable.
    "
    def authorize
      Middleware.sequence_authorize.call({})
    end

    desc "droplets", "Retrieve a list of your droplets"
    def droplets
      Middleware.sequence_list_droplets.call({})
    end

    desc "images", "Retrieve a list of your images"
    method_option "global",
                  :type => :boolean,
                  :default => false,
                  :aliases => "-g",
                  :desc => "Show global images"
    def images
      Middleware.sequence_list_images.call({
        "user_show_global_images" => options[:global],
        })
    end

    desc "ssh FUZZY_NAME", "SSH into a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def ssh(name=nil)
      Middleware.sequence_ssh_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "create NAME", "Create a droplet."
    method_option  "size",
                   :type => :numeric,
                   :aliases => "-s",
                   :default => 64,
                   :desc => "The size_id of the droplet"
    method_option  "image",
                   :type => :numeric,
                   :aliases => "-i",
                   :default => 2676,
                   :desc => "The image_id of the droplet"
    method_option  "region",
                   :type => :numeric,
                   :aliases => "-r",
                   :default => 1,
                   :desc => "The region_id of the droplet"
    method_option  "keys",
                   :type => :string,
                   :aliases => "-k",
                   :desc => "A comma separated list of SSH key ids to add to the droplet"
    def create(name)
      Middleware.sequence_create_droplet.call({
        "create_droplet_size_id" => options[:size],
        "create_droplet_image_id" => options[:image],
        "create_droplet_region_id" => options[:region],
        "create_droplet_ssh_key_ids" => options[:keys],
        "create_droplet_name" => name
      })
    end

    desc "destroy FUZZY_NAME", "Destroy a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def destroy(name=nil)
      Middleware.sequence_destroy_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "restart FUZZY_NAME", "Restart a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def restart(name=nil)
      Middleware.sequence_restart_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "halt FUZZY_NAME", "Shutdown a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def halt(name=nil)
      Middleware.sequence_halt_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "info FUZZY_NAME [OPTIONS]", "Show a droplet's information"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def info(name=nil)
      Middleware.sequence_info_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "snapshot SNAPSHOT_NAME FUZZY_NAME [OPTIONS]", "Queue a snapshot of the droplet."
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def snapshot(snapshot_name, name=nil)
      Middleware.sequence_snapshot_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_snapshot_name" => snapshot_name
      })
    end

    desc "keys", "Show available SSH keys"
    def keys
      Middleware.sequence_ssh_keys.call({})
    end
  end
end

