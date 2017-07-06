package com.rgsone.fenrir.utils;

import Array;
import haxe.io.Path;
import sys.FileSystem;

class SDKUtils
{
	private static var envDelimiter:String = ":";
	private static var javaExecFilename:String = "java";
	private static var adtExecFilename:String = "adt";
	private static var adlExecFilename:String = "adl";
	private static inline var airSdkDescriptionFilename:String = "air-sdk-description.xml";

	public static function isValidSdk( path:String ):Bool
	{
		if ( null == path ) return false;

		var airSdkDescriptionPath:String = Path.join([ path, airSdkDescriptionFilename ]);

		if ( !FileSystem.exists( airSdkDescriptionPath ) || FileSystem.isDirectory( airSdkDescriptionPath ) ) return false;

		var adlPath:String = Path.join([ path, "bin", adlExecFilename ]);
		var adtPath:String = Path.join([ path, "bin", adtExecFilename ]);

		if ( !FileSystem.exists( adlPath ) || FileSystem.isDirectory( adlPath ) ||
			 !FileSystem.exists( adtPath ) || FileSystem.isDirectory( adtPath ) )
		{
			return false;
		}

		return true;
	}

	public static function findJava():String
	{
		var env:Map<String, String> = Sys.environment();
		var javaExecPath:String= null;

		if ( !env.exists( "JAVA_HOME" ) )
		{
			javaExecPath = Path.join([ env.get( "JAVA_HOME" ), "bin", javaExecFilename ]);
			if ( FileSystem.exists( javaExecPath ) ) return javaExecPath;
		}

		if ( env.exists( "PATH" ) )
		{
			javaExecPath = findJavaForPath( env.get( "PATH" ) );
			if ( null != javaExecPath ) return javaExecPath;
		}

		if ( env.exists( "Path" ) )
		{
			javaExecPath = findJavaForPath( env.get( "Path" ) );
			if ( null != javaExecPath ) return javaExecPath;
		}

		return null;
	}

	public static function getAdtExecPath( sdkPath:String ):String
	{
		return Path.join([ sdkPath, "bin", adtExecFilename ]);
	}

	public static function setSystemDefaults():Void
	{
		if ( Sys.systemName() == "Windows")
		{
			javaExecFilename += ".exe";
			adtExecFilename += ".bat";
			adlExecFilename += ".exe";
			envDelimiter = ";";
		}
	}

	private static function findJavaForPath( pathsString:String ):String
	{
		var paths:Array<String> = pathsString.split( envDelimiter );
		var curJavaPath:String;

		for ( path in paths )
		{
			curJavaPath = Path.join([ path, javaExecFilename ]);
			if ( FileSystem.exists( curJavaPath ) ) return curJavaPath;
		}

		return null;
	}
}
