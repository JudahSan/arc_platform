# Makefile for Africa Ruby Community (ARC) Platform

# Variables
RUBY_VERSION = 3.4.1
NODE_VERSION = 20.9.0
ASDF = $(HOME)/.asdf/asdf.sh
SHELL = /bin/bash

# Targets
.PHONY: install-asdf install-ruby install-node install-deps setup-db start-server install-yarn-deps

# Install ASDF
install-asdf:
	@echo "Installing ASDF..."
	git clone https://github.com/excid3/asdf.git $(HOME)/.asdf
	echo '. "$(HOME)/.asdf/asdf.sh"' >> $(HOME)/.zshrc
	echo '. "$(HOME)/.asdf/completions/asdf.bash"' >> $(HOME)/.zshrc
	echo 'legacy_version_file = yes' >> $(HOME)/.asdfrc
	exec $(SHELL)

# Install Ruby via ASDF
install-ruby:
	@echo "Installing Ruby $(RUBY_VERSION)..."
	. $(ASDF) && asdf plugin add ruby
	. $(ASDF) && asdf install ruby $(RUBY_VERSION)
	. $(ASDF) && asdf global ruby $(RUBY_VERSION)
	gem update --system
	gem install foreman

# Install Node.js via ASDF
install-node:
	@echo "Installing Node.js $(NODE_VERSION)..."
	. $(ASDF) && asdf plugin add nodejs
	. $(ASDF) && asdf install nodejs $(NODE_VERSION)
	. $(ASDF) && asdf global nodejs $(NODE_VERSION)
	npm install -g yarn

# Install project dependencies
install-deps:
	@echo "Installing Ruby dependencies..."
	bundle install
	@echo "Installing Yarn dependencies..."
	yarn install

# Setup the database
setup-db:
	@echo "Setting up the database..."
	rails db:create
	rails db:migrate

# Start the development server
start-server:
	@echo "Starting the server..."
	./bin/dev

# Install Yarn dependencies
install-yarn-deps:
	@echo "Installing Yarn dependencies..."
	yarn install

# Full setup (ASDF, Ruby, Node, Dependencies, Database)
setup: install-asdf install-ruby install-node install-deps setup-db

# Default target
all: setup start-server
