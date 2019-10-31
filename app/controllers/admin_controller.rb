class AdminController < ApplicationController
  def init
    Site.create domain: "local", itskey: "local", mykey: "local"
    Site.create domain: "whesh.com", itskey: "wesh.com", mykey: "wesh.com"
    ApplicationSetting.create vote_timeline: 7, vote_min_valid: 100
    User.create name: "a", passwd: "$2a$12$4UGpnS3d5otoGi0OCEBovecxhJui2k3iClGbON.8RLU3vuBXuFkD.", voter_hash: "4bba9931c0b8ff4055f8b104fbc26818"
    redirect_to "/"
  end
end
