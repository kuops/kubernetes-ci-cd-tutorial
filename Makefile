INGRESS_NODE_IP ?= $(shell printenv INGRESS_NODE_IP)
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
BUILD_CMD = $(shell find . -type f -name *.yaml -exec sed -i "s@{.INGRESS_NODE_IP}@${INGRESS_NODE_IP}@g" {} +)
else ifeq ($(UNAME_S),Darwin)
BUILD_CMD = $(shell find . -type f -name *.yaml -exec sed -i '' "s@{.INGRESS_NODE_IP}@${INGRESS_NODE_IP}@g" {} +)
endif

build:
ifeq ($(INGRESS_NODE_IP),)
	@printf "The INGRESS_NODE_IP $(INGRESS_NODE_IP) not defined.\n" 
else
	@$(BUILD_CMD) \
	printf "Replace virtualservice {.INGRESS_NODE_IP} to %s finished\n" $(INGRESS_NODE_IP)
endif
