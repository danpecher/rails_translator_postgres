RailsTranslator::Engine.routes.draw do
	get '/' => 'index#index', as: :index
	post '/' => 'index#update'
end
