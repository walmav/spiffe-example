pluginName = "join_token" //needs to match the name used in plugin serverConfig

pluginCmd = "plugin/server/nodeattestor-jointoken"
pluginChecksum = ""
enabled = true
pluginType = "NodeAttestor" //needs to match the handshake
pluginData {
	join_tokens {
		TokenBlog = 600,
		TokenDatabase = 600
	},
	trust_domain = "example.org"
}
