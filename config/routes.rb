Rails.application.routes.draw do
  get 'play', to: 'games#play'
  get 'seeresult', to: 'games#seeresult'
end
