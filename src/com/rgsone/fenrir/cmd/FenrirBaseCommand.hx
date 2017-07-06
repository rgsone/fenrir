package com.rgsone.fenrir.cmd;

import massive.neko.cmd.Command;

class FenrirBaseCommand extends Command
{
	public var config( null, set ):FenrirConfig;
	private function set_config( config:FenrirConfig ):FenrirConfig
	{
		return this.config = config;
	}

	public var fenrir( null, set ):Fenrir;
	private function set_fenrir( fenrir:Fenrir ):Fenrir
	{
		return this.fenrir = fenrir;
	}

	public function new( fenrir:Fenrir, config:FenrirConfig ):Void
	{
		super();

		this.fenrir = fenrir;
		this.config = config;
	}
}
