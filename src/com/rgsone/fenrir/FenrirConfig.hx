package com.rgsone.fenrir;

import haxe.io.Path;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class FenrirConfig
{
	private static inline var FENRIR_JSON_FILENAME:String = "fenrir.json";

	public var configFile( default, null ):String;
	public var config( default, null ):FenrirConfigStruct;

	public function new( basePath:String )
	{
		configFile = Path.join([ basePath, FENRIR_JSON_FILENAME ]);
	}

	public function configFileExist():Bool
	{
		return ( FileSystem.exists( configFile ) && !FileSystem.isDirectory( configFile ) );
	}

	public function load():Void
	{
		if ( !configFileExist() )
		{
			throw "fenrir.json not found...";
			return;
		}

		var configContent:String = File.getContent( configFile );
		config = Json.parse( configContent );
	}
}

typedef FenrirConfigStruct = {
	var airsdk:String;
	@:optional var certificat:FenrirConfigCertificatStruct;
}

typedef FenrirConfigCertificatStruct = {
	var name:String;
	@:optional var organizationalUnit:String;
	@:optional var organization:String;
	@:optional var countryCode:String;
	@:optional var validityPeriod:String;
	@:optional var keyType:String;
	@:optional var output:String;
	@:optional var password:String;
}
