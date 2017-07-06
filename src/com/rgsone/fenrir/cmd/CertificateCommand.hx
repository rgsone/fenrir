package com.rgsone.fenrir.cmd;

import com.rgsone.fenrir.cmd.FenrirBaseCommand;
import com.rgsone.fenrir.FenrirConfig.FenrirConfigCertificatStruct;
import com.rgsone.fenrir.utils.SDKUtils;

class CertificateCommand extends FenrirBaseCommand
{
	private static inline var adtCommand:String = "-certificate";

	private static inline var defaultKeyType:String = "2048-RSA";
	private static inline var defaultOutput:String = "cert.p12";
	private static inline var defaultPassword:String = "default";

	private var certificatConf:FenrirConfigCertificatStruct = {
		name: null,
		organizationalUnit: null,
		organization: null,
		countryCode: null,
		validityPeriod: null,
		keyType: null,
		output: null,
		password: null
	};
	private var args:Array<String> = [];

	override public function execute():Void
	{
		checkConf();
		populateConf();
		checkDefaultPassword();
		buildArgs();

		Sys.println( "Generate certificate with ADT..." );

		var adt:String = SDKUtils.getAdtExecPath( config.config.airsdk );
		var code = Sys.command( adt, args );

		if ( code > 0 ) exit( code );

		Sys.println( "Done !" );
	}

	private function checkConf():Void
	{
		if ( config.config.certificat == null )
		{
			print( ">>>> certificat config not found" );
			exit( 1 );
		}

		if ( config.config.certificat.name == null )
		{
			print( ">>>> certificat name is required" );
			exit( 1 );
		}
	}

	private function populateConf():Void
	{
		certificatConf.name = config.config.certificat.name;
		certificatConf.organizationalUnit = config.config.certificat.organizationalUnit;
		certificatConf.organization = config.config.certificat.organization;
		certificatConf.countryCode = config.config.certificat.countryCode;
		certificatConf.validityPeriod = config.config.certificat.validityPeriod;
		certificatConf.keyType = defaultKeyType;
		certificatConf.output = ( config.config.certificat.output == null ) ? defaultOutput : config.config.certificat.output;
		certificatConf.password = ( config.config.certificat.password == null ) ? defaultPassword : config.config.certificat.password;
	}

	private function checkDefaultPassword():Void
	{
		if ( certificatConf.password == defaultPassword )
		{
			print( "WARNING : You did not change the default password." );
		}

		if ( certificatConf.password.length < 1 )
		{
			certificatConf.password = defaultPassword;
			print( "WARNING : password is empty, replace with default password." );
		}
	}

	private function buildArgs():Void
	{
		/*
		>> adt -certificate -cn name -ou orgUnit -o orgName -c country -validityPeriod years key-type output password

		-cn The string assigned as the common name of the new certificate.
		-ou A string assigned as the organizational unit issuing the certificate. (Optional.)
		-o A string assigned as the organization issuing the certificate. (Optional.)
		-c A two-letter ISO-3166 country code. A certificate is not generated if an invalid code is supplied. (Optional.)
		-validityPeriod The number of years that the certificate will be valid. If not specified a validity of five years is assigned. (Optional.)
		key_type The type of key to use for the certificate is 2048-RSA.
		output The path and file name for the certificate file to be generated.
		password The password for accessing the new certificate. The password is required when signing AIR files with this certificate.
		*/

		args.push( "-certificate" );
		args.push( "-cn" );
		args.push( certificatConf.name );

		if ( certificatConf.organizationalUnit != null )
		{
			args.push( "-ou" );
			args.push( certificatConf.organizationalUnit );
		}

		if ( certificatConf.organization != null )
		{
			args.push( "-o" );
			args.push( certificatConf.organization );
		}

		if ( certificatConf.countryCode != null )
		{
			args.push( "-c" );
			args.push( certificatConf.countryCode );
		}

		if ( certificatConf.validityPeriod != null )
		{
			args.push( "-validityPeriod" );
			args.push( certificatConf.validityPeriod );
		}

		args.push( certificatConf.keyType );
		args.push( certificatConf.output );
		args.push( certificatConf.password );
	}

	private function addArg( name:String ):String
	{
		return "";
	}
}
