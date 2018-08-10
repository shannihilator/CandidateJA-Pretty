Rails.application.routes.draw do
  root to: "home#index"

  get 'home/displayFreq'
  get 'home/displayDup'
end
