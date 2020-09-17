ARG BASE_IMAGE
FROM azurecli:latest

# Update and install needed packages
RUN apk update
RUN apk add busybox-suid #needed for https://bugs.archlinux.org/task/25999

# Install kubectl
RUN az aks install-cli

# Install helm
# Note: Latest version of helm may be found at: https://github.com/helm/helm/releases/
# When updating the version remember to update the build.yaml tag
ENV HELM_VERSION="v2.14.2"
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

# Update urllib3 package due to CVE-2020-7212
RUN pip install --upgrade urllib3

# Create and run container as non-root user by default due to security concerns
RUN adduser -D local
USER local
