package com.rgsone.fenrir;

import com.rgsone.fenrir.cmd.CertificateCommand;
import com.rgsone.fenrir.cmd.FenrirBaseCommand;
import com.rgsone.fenrir.utils.SDKUtils;
import massive.sys.cmd.CommandLineRunner;
import massive.sys.cmd.Console;
import massive.sys.cmd.ICommand;

class Fenrir extends CommandLineRunner
{
	private static inline var VERSION = "0.1.0";

	private var _config:FenrirConfig;
	private var _javaExecFile:String;

	public function new():Void
	{
		super();

		SDKUtils.setSystemDefaults();
		checkJava();
		loadConfig();
		validateSdk();

		mapCommand( CertificateCommand, "certificat", [ "cert" ], "create a self-signed digital code signing certificate" );

		run();
	}

	private function checkJava():Void
	{
		_javaExecFile = SDKUtils.findJava();

		if ( null == _javaExecFile )
			printError( "Java not found ! AIR SDK require java to run." );
	}

	private function loadConfig():Void
	{
		var configPath:String = ( null != console.getOption( "config" ) ) ? console.getOption( "config" ) : Sys.getCwd();

		_config = new FenrirConfig( configPath );

		if ( !_config.configFileExist() )
			printError( "fenrir.json file not found..." );

		try {
			_config.load();
		} catch( e:Dynamic ) {
			printError( "error when parsing fenrir.json" );
		}
	}

	private function validateSdk():Void
	{
		if ( !SDKUtils.isValidSdk( _config.config.airsdk ) )
			printError( "AIR SDK is not valid..." );
	}

	private function printError( errorMsg:String ):Void
	{
		printInfo();
		print( ">>>> " + errorMsg );
		print( "" );
		printCommands();
		exit( 1 );
	}

	override private function createConsole():Console
	{
		return new Console( false );
	}

	override private function createCommandInstance( commandClass:Class<ICommand> ):ICommand
	{
		var cmd:FenrirBaseCommand = cast( Type.createInstance( commandClass, [ this, _config ] ), FenrirBaseCommand );
		cmd.console = console;

		return cmd;
	}

	override public function printCommands():Void
	{
		super.printCommands();

		print( "Options :" );
		print( "   -config <path> : path to fenrir.json, by default fenrir look in current directory" );
	}

	override public function printHeader():Void
	{
		printInfo();
	}

	private function printInfo():Void
	{
		Sys.println( "" );
		Sys.println( "-----------------------------------------------------" );
		Sys.println( "         ______ ______ _   __ ____   ____ ____       " );
		Sys.println( "        / ____// ____// | / // __ \\ /  _// __ \\      " );
		Sys.println( "       / /_   / __/  /  |/ // /_/ / / / / /_/ /      " );
		Sys.println( "      / __/  / /___ / /|  // _, _/_/ / / _, _/       " );
		Sys.println( "     /_/    /_____//_/ |_//_/ |_|/___//_/ |_|        " );
		Sys.println( "                                                     " );
		Sys.println( "        Fenrir | AIRSDK CLI tools (v" + VERSION + ")    " );
		Sys.println( "-----------------------------------------------------" );
		Sys.println( "" );
	}

	private static function main():Fenrir
	{
		return new Fenrir();
	}
}
