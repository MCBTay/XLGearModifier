Shader "MasterShaderCloth_v2" {
	Properties {
		[NoScaleOffset] _texture2D_color ("Texture Color", 2D) = "white" {}
		[NoScaleOffset] _texture2D_alphacut ("Texture Alpha  Cut", 2D) = "white" {}
		_scalar_hueshift ("Hue Shift", Range(0, 1)) = 0
		_scalar_saturation ("Saturation", Range(0, 2)) = 1
		[NoScaleOffset] _texture2D_normal ("Texture Normap Map", 2D) = "white" {}
		_scalar_intNormal ("Intensity Normal Map", Range(0, 2)) = 1
		[NoScaleOffset] _texture2D_maskPBR ("Texture RgSpAo", 2D) = "white" {}
		_scalar_minrg ("Min Roughness", Range(0, 1)) = 0
		_scalar_maxrg ("Max Roughness", Range(0, 1)) = 1
		_scalar_minspecular ("Min Specular", Range(0, 1)) = 0
		_scalar_maxspecular ("Max Specular", Range(0, 1)) = 1
		[ToggleUI] _multiply_specular ("Multiply Specular Value x Texture Color", Float) = 0
		Vector1_60D43DF8 ("Alpha Cut Threshold", Range(0, 1)) = 0.2
		[HideInInspector] _EmissionColor ("Color", Vector) = (1,1,1,1)
		[HideInInspector] _RenderQueueType ("Vector1", Float) = 1
		[HideInInspector] _StencilRef ("Vector1", Float) = 0
		[HideInInspector] _StencilWriteMask ("Vector1", Float) = 6
		[HideInInspector] _StencilRefDepth ("Vector1", Float) = 8
		[HideInInspector] _StencilWriteMaskDepth ("Vector1", Float) = 8
		[HideInInspector] _StencilRefMV ("Vector1", Float) = 40
		[HideInInspector] _StencilWriteMaskMV ("Vector1", Float) = 40
		[HideInInspector] _StencilRefDistortionVec ("Vector1", Float) = 4
		[HideInInspector] _StencilWriteMaskDistortionVec ("Vector1", Float) = 4
		[HideInInspector] _StencilWriteMaskGBuffer ("Vector1", Float) = 14
		[HideInInspector] _StencilRefGBuffer ("Vector1", Float) = 10
		[HideInInspector] _ZTestGBuffer ("Vector1", Float) = 4
		[ToggleUI] [HideInInspector] _RequireSplitLighting ("Boolean", Float) = 0
		[ToggleUI] [HideInInspector] _ReceivesSSR ("Boolean", Float) = 1
		[HideInInspector] _SurfaceType ("Vector1", Float) = 0
		[HideInInspector] _BlendMode ("Vector1", Float) = 0
		[HideInInspector] _SrcBlend ("Vector1", Float) = 1
		[HideInInspector] _DstBlend ("Vector1", Float) = 0
		[HideInInspector] _AlphaSrcBlend ("Vector1", Float) = 1
		[HideInInspector] _AlphaDstBlend ("Vector1", Float) = 0
		[ToggleUI] [HideInInspector] _ZWrite ("Boolean", Float) = 1
		[ToggleUI] [HideInInspector] _TransparentZWrite ("Boolean", Float) = 0
		[HideInInspector] _CullMode ("Vector1", Float) = 2
		[HideInInspector] _TransparentSortPriority ("Vector1", Float) = 0
		[ToggleUI] [HideInInspector] _EnableFogOnTransparent ("Boolean", Float) = 1
		[HideInInspector] _CullModeForward ("Vector1", Float) = 2
		[Enum(Front, 1, Back, 2)] [HideInInspector] _TransparentCullMode ("Vector1", Float) = 2
		[HideInInspector] _ZTestDepthEqualForOpaque ("Vector1", Float) = 4
		[Enum(UnityEngine.Rendering.CompareFunction)] [HideInInspector] _ZTestTransparent ("Vector1", Float) = 4
		[ToggleUI] [HideInInspector] _TransparentBackfaceEnable ("Boolean", Float) = 0
		[ToggleUI] [HideInInspector] _AlphaCutoffEnable ("Boolean", Float) = 1
		[ToggleUI] [HideInInspector] _UseShadowThreshold ("Boolean", Float) = 0
		[ToggleUI] [HideInInspector] _DoubleSidedEnable ("Boolean", Float) = 0
		[Enum(Flip, 0, Mirror, 1, None, 2)] [HideInInspector] _DoubleSidedNormalMode ("Vector1", Float) = 2
		[HideInInspector] _DoubleSidedConstants ("Vector4", Vector) = (1,1,-1,0)
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest+0" "RenderPipeline" = "HDRenderPipeline" "RenderType" = "HDLitShader" }
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest+0" "RenderPipeline" = "HDRenderPipeline" "RenderType" = "HDLitShader" }
			ColorMask 0 -1
			ZClip Off
			Cull Off
			GpuProgramID 26682
			Program "vp" {
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						vec4 unused_0_1[33];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec4 in_TEXCOORD0;
					layout(location = 0) out vec4 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.x = dot(u_xlat0, u_xlat2);
					    u_xlat0 = u_xlat0.xxxx * _ViewProjMatrix[1];
					    u_xlat3.w = u_xlat1.x;
					    u_xlat3.x = unity_ObjectToWorld[0].x;
					    u_xlat3.y = unity_ObjectToWorld[1].x;
					    u_xlat3.z = unity_ObjectToWorld[2].x;
					    u_xlat3.x = dot(u_xlat3, u_xlat2);
					    u_xlat0 = _ViewProjMatrix[0] * u_xlat3.xxxx + u_xlat0;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat1.x = dot(u_xlat1, u_xlat2);
					    u_xlat0 = _ViewProjMatrix[2] * u_xlat1.xxxx + u_xlat0;
					    gl_Position = u_xlat0 + _ViewProjMatrix[3];
					    vs_TEXCOORD0 = in_TEXCOORD0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						vec4 unused_0_1[33];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec4 in_TEXCOORD0;
					layout(location = 0) out vec4 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.x = dot(u_xlat0, u_xlat2);
					    u_xlat0 = u_xlat0.xxxx * _ViewProjMatrix[1];
					    u_xlat3.w = u_xlat1.x;
					    u_xlat3.x = unity_ObjectToWorld[0].x;
					    u_xlat3.y = unity_ObjectToWorld[1].x;
					    u_xlat3.z = unity_ObjectToWorld[2].x;
					    u_xlat3.x = dot(u_xlat3, u_xlat2);
					    u_xlat0 = _ViewProjMatrix[0] * u_xlat3.xxxx + u_xlat0;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat1.x = dot(u_xlat1, u_xlat2);
					    u_xlat0 = _ViewProjMatrix[2] * u_xlat1.xxxx + u_xlat0;
					    gl_Position = u_xlat0 + _ViewProjMatrix[3];
					    vs_TEXCOORD0 = in_TEXCOORD0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						vec4 unused_0_1[33];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec4 in_TEXCOORD0;
					layout(location = 0) out vec4 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.x = dot(u_xlat0, u_xlat2);
					    u_xlat0 = u_xlat0.xxxx * _ViewProjMatrix[1];
					    u_xlat3.w = u_xlat1.x;
					    u_xlat3.x = unity_ObjectToWorld[0].x;
					    u_xlat3.y = unity_ObjectToWorld[1].x;
					    u_xlat3.z = unity_ObjectToWorld[2].x;
					    u_xlat3.x = dot(u_xlat3, u_xlat2);
					    u_xlat0 = _ViewProjMatrix[0] * u_xlat3.xxxx + u_xlat0;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat1.x = dot(u_xlat1, u_xlat2);
					    u_xlat0 = _ViewProjMatrix[2] * u_xlat1.xxxx + u_xlat0;
					    gl_Position = u_xlat0 + _ViewProjMatrix[3];
					    vs_TEXCOORD0 = in_TEXCOORD0;
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					void main()
					{
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					void main()
					{
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerMaterial {
						vec4 unused_0_0[2];
						float Vector1_60D43DF8;
						vec4 unused_0_2[11];
					};
					layout(location = 1) uniform  sampler2D _texture2D_alphacut;
					layout(location = 0) in  vec4 vs_TEXCOORD0;
					float u_xlat0;
					float u_xlat10_0;
					bool u_xlatb0;
					void main()
					{
					    u_xlat10_0 = texture(_texture2D_alphacut, vs_TEXCOORD0.xy).x;
					    u_xlat0 = u_xlat10_0 + (-Vector1_60D43DF8);
					    u_xlatb0 = u_xlat0<0.0;
					    if(((int(u_xlatb0) * int(0xffffffffu)))!=0){discard;}
					    return;
					}"
				}
			}
		}
		Pass {
			Name "DepthOnly"
			Tags { "LIGHTMODE" = "DepthOnly" "QUEUE" = "AlphaTest+0" "RenderPipeline" = "HDRenderPipeline" "RenderType" = "HDLitShader" }
			Cull Off
			Stencil {
				WriteMask 0
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 213437
			Program "vp" {
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 6) in  vec4 in_TEXCOORD3;
					layout(location = 7) in  vec4 in_COLOR0;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					layout(location = 6) out vec4 vs_TEXCOORD6;
					layout(location = 7) out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    vs_TEXCOORD6 = in_TEXCOORD3;
					    vs_TEXCOORD7 = in_COLOR0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 6) in  vec4 in_TEXCOORD3;
					layout(location = 7) in  vec4 in_COLOR0;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					layout(location = 6) out vec4 vs_TEXCOORD6;
					layout(location = 7) out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    vs_TEXCOORD6 = in_TEXCOORD3;
					    vs_TEXCOORD7 = in_COLOR0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 6) in  vec4 in_TEXCOORD3;
					layout(location = 7) in  vec4 in_COLOR0;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					layout(location = 6) out vec4 vs_TEXCOORD6;
					layout(location = 7) out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    vs_TEXCOORD6 = in_TEXCOORD3;
					    vs_TEXCOORD7 = in_COLOR0;
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					void main()
					{
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					void main()
					{
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerMaterial {
						vec4 unused_0_0[2];
						float Vector1_60D43DF8;
						vec4 unused_0_2[11];
					};
					layout(location = 1) uniform  sampler2D _texture2D_alphacut;
					layout(location = 0) in  vec4 vs_TEXCOORD3;
					float u_xlat0;
					float u_xlat10_0;
					bool u_xlatb0;
					void main()
					{
					    u_xlat10_0 = texture(_texture2D_alphacut, vs_TEXCOORD3.xy).x;
					    u_xlat0 = u_xlat10_0 + (-Vector1_60D43DF8);
					    u_xlatb0 = u_xlat0<0.0;
					    if(((int(u_xlatb0) * int(0xffffffffu)))!=0){discard;}
					    return;
					}"
				}
			}
		}
		Pass {
			Name "GBuffer"
			Tags { "LIGHTMODE" = "GBuffer" "QUEUE" = "AlphaTest+0" "RenderPipeline" = "HDRenderPipeline" "RenderType" = "HDLitShader" }
			Cull Off
			Stencil {
				WriteMask 0
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 306573
			Program "vp" {
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "SHADOWS_SHADOWMASK" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "SHADOWS_SHADOWMASK" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "_DOUBLESIDED_ON" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" }
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[29];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[20];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_4[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 0) out vec3 vs_TEXCOORD0;
					layout(location = 1) out vec3 vs_TEXCOORD1;
					layout(location = 2) out vec4 vs_TEXCOORD2;
					layout(location = 3) out vec4 vs_TEXCOORD3;
					layout(location = 4) out vec4 vs_TEXCOORD4;
					layout(location = 5) out vec4 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					float u_xlat15;
					void main()
					{
					    u_xlat0.x = unity_ObjectToWorld[0].y;
					    u_xlat0.y = unity_ObjectToWorld[1].y;
					    u_xlat0.z = unity_ObjectToWorld[2].y;
					    u_xlat1.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat0.w = u_xlat1.y;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat0.y = dot(u_xlat0, u_xlat2);
					    u_xlat3 = u_xlat0.yyyy * _ViewProjMatrix[1];
					    u_xlat4.w = u_xlat1.x;
					    u_xlat4.x = unity_ObjectToWorld[0].x;
					    u_xlat4.y = unity_ObjectToWorld[1].x;
					    u_xlat4.z = unity_ObjectToWorld[2].x;
					    u_xlat0.x = dot(u_xlat4, u_xlat2);
					    u_xlat3 = _ViewProjMatrix[0] * u_xlat0.xxxx + u_xlat3;
					    u_xlat1.x = unity_ObjectToWorld[0].z;
					    u_xlat1.y = unity_ObjectToWorld[1].z;
					    u_xlat1.z = unity_ObjectToWorld[2].z;
					    u_xlat0.z = dot(u_xlat1, u_xlat2);
					    u_xlat1 = _ViewProjMatrix[2] * u_xlat0.zzzz + u_xlat3;
					    vs_TEXCOORD0.xyz = u_xlat0.xyz;
					    gl_Position = u_xlat1 + _ViewProjMatrix[3];
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD1.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = inversesqrt(u_xlat15);
					    vs_TEXCOORD2.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unused_0_14[10];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat10_7;
					vec3 u_xlat8;
					bool u_xlatb8;
					float u_xlat10;
					vec3 u_xlat12;
					uvec2 u_xlatu16;
					bvec2 u_xlatb18;
					vec2 u_xlat10_21;
					float u_xlat24;
					float u_xlat16_24;
					float u_xlat10_24;
					float u_xlat25;
					bool u_xlatb25;
					float u_xlat26;
					bool u_xlatb26;
					float u_xlat27;
					bool u_xlatb27;
					float u_xlat28;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb8 = 0.0<vs_TEXCOORD2.w;
					    u_xlat8.x = (u_xlatb8) ? 1.0 : -1.0;
					    u_xlat8.x = u_xlat8.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat8.xyz = u_xlat8.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat8.xyz = u_xlat0.xxx * u_xlat8.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat4.x>=u_xlat4.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xy = u_xlat4.yx;
					    u_xlat5.z = float(-1.0);
					    u_xlat5.w = float(0.666666687);
					    u_xlat6.xy = u_xlat4.xy + (-u_xlat5.xy);
					    u_xlat6.z = float(1.0);
					    u_xlat6.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlatb0 = u_xlat4.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat4.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat4.wyx;
					    u_xlat5 = (-u_xlat4) + u_xlat5;
					    u_xlat4 = u_xlat0.xxxx * u_xlat5 + u_xlat4;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat25 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat4.z;
					    u_xlat26 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlatb26 = 1.0<abs(u_xlat25);
					    u_xlat27 = abs(u_xlat25) + -1.0;
					    u_xlat25 = (u_xlatb26) ? u_xlat27 : abs(u_xlat25);
					    u_xlat12.xyz = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat12.xyz = fract(u_xlat12.xyz);
					    u_xlat12.xyz = u_xlat12.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat12.xyz = abs(u_xlat12.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = clamp(u_xlat12.xyz, 0.0, 1.0);
					    u_xlat12.xyz = u_xlat12.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = u_xlat0.xxx * u_xlat12.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyw = u_xlat12.yzx * u_xlat4.xxx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat4.xy = u_xlat4.xx * u_xlat12.yz + (-u_xlat6.xy);
					    u_xlat4.z = float(1.0);
					    u_xlat4.w = float(-1.0);
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat4.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat4.xyw;
					    u_xlat4.xyw = u_xlat5.wyx;
					    u_xlat4 = (-u_xlat5) + u_xlat4;
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat5;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat25 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat4.z;
					    u_xlat26 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlat25 = abs(u_xlat25) + _scalar_hueshift;
					    u_xlatb26 = u_xlat25<0.0;
					    u_xlatb27 = 1.0<u_xlat25;
					    u_xlat12.xy = vec2(u_xlat25) + vec2(1.0, -1.0);
					    u_xlat25 = (u_xlatb27) ? u_xlat12.y : u_xlat25;
					    u_xlat25 = (u_xlatb26) ? u_xlat12.x : u_xlat25;
					    u_xlat12.xyz = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat12.xyz = fract(u_xlat12.xyz);
					    u_xlat12.xyz = u_xlat12.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat12.xyz = abs(u_xlat12.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = clamp(u_xlat12.xyz, 0.0, 1.0);
					    u_xlat12.xyz = u_xlat12.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = u_xlat0.xxx * u_xlat12.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyz = u_xlat12.xyz * u_xlat4.xxx;
					    u_xlat0.x = dot(u_xlat5.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xyz = u_xlat4.xxx * u_xlat12.xyz + (-u_xlat0.xxx);
					    u_xlat4.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xyz + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat25 = _scalar_intNormal;
					    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat25 * u_xlat0.x + 1.0;
					    u_xlat10_21.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat25 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat25 = u_xlat10_21.x * u_xlat25 + _scalar_minrg;
					    u_xlat25 = (-u_xlat25) + 1.0;
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat5.yyy;
					    u_xlat8.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat8.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat8.xyz;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat24 = inversesqrt(u_xlat24);
					    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    u_xlatb1 = unity_ProbeVolumeParams.x==0.0;
					    if(u_xlatb1){
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(unity_SHAr, u_xlat0);
					        u_xlat1.y = dot(unity_SHAg, u_xlat0);
					        u_xlat1.z = dot(unity_SHAb, u_xlat0);
					        u_xlat2 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat2);
					        u_xlat5.y = dot(unity_SHBg, u_xlat2);
					        u_xlat5.z = dot(unity_SHBb, u_xlat2);
					        u_xlat2.x = u_xlat0.y * u_xlat0.y;
					        u_xlat2.x = u_xlat0.x * u_xlat0.x + (-u_xlat2.x);
					        u_xlat2.xyz = unity_SHC.xyz * u_xlat2.xxx + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat2.xyz;
					    } else {
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb26 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					        u_xlat2.xyz = (bool(u_xlatb26)) ? u_xlat2.xyz : vs_TEXCOORD0.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat2.yzw = u_xlat2.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat10 = u_xlat2.y * 0.25;
					        u_xlat27 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat28 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat10 = max(u_xlat10, u_xlat27);
					        u_xlat2.x = min(u_xlat28, u_xlat10);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat2.xzw, 0.0);
					        u_xlat5.xyz = u_xlat2.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat2.xyz = u_xlat2.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_2 = textureLod(unity_ProbeVolumeSH, u_xlat2.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(u_xlat10_6, u_xlat0);
					        u_xlat1.y = dot(u_xlat10_7, u_xlat0);
					        u_xlat1.z = dot(u_xlat10_2, u_xlat0);
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat25) + 1.0;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat24 = max(u_xlat24, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat24);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_24 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_24 = u_xlat10_24 + 0.5;
					    u_xlat2.xzw = u_xlat4.xyz * vec3(u_xlat16_24);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat24 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb25 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb25) ? u_xlat24 : (-u_xlat24);
					    u_xlat24 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat24 = float(1.0) / float(u_xlat24);
					    u_xlat2.xzw = vec3(u_xlat24) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb18.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb18.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb18.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat24) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu16.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu16.y * 16u + u_xlatu16.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_21.yyy * u_xlat1.xyz;
					    u_xlat24 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat24 = u_xlat24 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xyz;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unused_0_14[10];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec3 u_xlat8;
					bool u_xlatb8;
					float u_xlat10;
					float u_xlat12;
					vec3 u_xlat13;
					uvec2 u_xlatu16;
					bvec2 u_xlatb18;
					vec2 u_xlat10_21;
					float u_xlat24;
					float u_xlat16_24;
					float u_xlat10_24;
					float u_xlat25;
					bool u_xlatb25;
					float u_xlat26;
					bool u_xlatb26;
					float u_xlat27;
					bool u_xlatb27;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb8 = 0.0<vs_TEXCOORD2.w;
					    u_xlat8.x = (u_xlatb8) ? 1.0 : -1.0;
					    u_xlat8.x = u_xlat8.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat8.xyz = u_xlat8.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat8.xyz = u_xlat0.xxx * u_xlat8.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlatb26 = 1.0<abs(u_xlat25);
					    u_xlat27 = abs(u_xlat25) + -1.0;
					    u_xlat25 = (u_xlatb26) ? u_xlat27 : abs(u_xlat25);
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlat25 = abs(u_xlat25) + _scalar_hueshift;
					    u_xlatb26 = u_xlat25<0.0;
					    u_xlatb27 = 1.0<u_xlat25;
					    u_xlat4.xz = vec2(u_xlat25) + vec2(1.0, -1.0);
					    u_xlat25 = (u_xlatb27) ? u_xlat4.z : u_xlat25;
					    u_xlat25 = (u_xlatb26) ? u_xlat4.x : u_xlat25;
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat13.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat13.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat25 = _scalar_intNormal;
					    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat25 * u_xlat0.x + 1.0;
					    u_xlat10_21.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat25 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat25 = u_xlat10_21.x * u_xlat25 + _scalar_minrg;
					    u_xlat25 = (-u_xlat25) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat5.yyy;
					    u_xlat8.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat8.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat8.xyz;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat24 = inversesqrt(u_xlat24);
					    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    u_xlatb1 = unity_ProbeVolumeParams.x==0.0;
					    if(u_xlatb1){
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(unity_SHAr, u_xlat0);
					        u_xlat1.y = dot(unity_SHAg, u_xlat0);
					        u_xlat1.z = dot(unity_SHAb, u_xlat0);
					        u_xlat2 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat2);
					        u_xlat5.y = dot(unity_SHBg, u_xlat2);
					        u_xlat5.z = dot(unity_SHBb, u_xlat2);
					        u_xlat2.x = u_xlat0.y * u_xlat0.y;
					        u_xlat2.x = u_xlat0.x * u_xlat0.x + (-u_xlat2.x);
					        u_xlat2.xyz = unity_SHC.xyz * u_xlat2.xxx + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat2.xyz;
					    } else {
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb26 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					        u_xlat2.xyz = (bool(u_xlatb26)) ? u_xlat2.xyz : vs_TEXCOORD0.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat2.yzw = u_xlat2.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat10 = u_xlat2.y * 0.25;
					        u_xlat27 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat12 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat10 = max(u_xlat10, u_xlat27);
					        u_xlat2.x = min(u_xlat12, u_xlat10);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat2.xzw, 0.0);
					        u_xlat5.xyz = u_xlat2.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat2.xyz = u_xlat2.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_2 = textureLod(unity_ProbeVolumeSH, u_xlat2.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(u_xlat10_6, u_xlat0);
					        u_xlat1.y = dot(u_xlat10_7, u_xlat0);
					        u_xlat1.z = dot(u_xlat10_2, u_xlat0);
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat25) + 1.0;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat24 = max(u_xlat24, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat24);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_24 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_24 = u_xlat10_24 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_24);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat24 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb25 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb25) ? u_xlat24 : (-u_xlat24);
					    u_xlat24 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat24 = float(1.0) / float(u_xlat24);
					    u_xlat2.xzw = vec3(u_xlat24) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb18.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb18.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb18.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat24) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu16.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu16.y * 16u + u_xlatu16.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_21.yyy * u_xlat1.xyz;
					    u_xlat24 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat24 = u_xlat24 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unused_0_14[10];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec3 u_xlat8;
					bool u_xlatb8;
					float u_xlat10;
					float u_xlat12;
					vec3 u_xlat13;
					uvec2 u_xlatu16;
					bvec2 u_xlatb18;
					vec2 u_xlat10_21;
					float u_xlat24;
					float u_xlat16_24;
					float u_xlat10_24;
					float u_xlat25;
					bool u_xlatb25;
					float u_xlat26;
					bool u_xlatb26;
					float u_xlat27;
					bool u_xlatb27;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb8 = 0.0<vs_TEXCOORD2.w;
					    u_xlat8.x = (u_xlatb8) ? 1.0 : -1.0;
					    u_xlat8.x = u_xlat8.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat8.xyz = u_xlat8.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat8.xyz = u_xlat0.xxx * u_xlat8.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlatb26 = 1.0<abs(u_xlat25);
					    u_xlat27 = abs(u_xlat25) + -1.0;
					    u_xlat25 = (u_xlatb26) ? u_xlat27 : abs(u_xlat25);
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlat25 = abs(u_xlat25) + _scalar_hueshift;
					    u_xlatb26 = u_xlat25<0.0;
					    u_xlatb27 = 1.0<u_xlat25;
					    u_xlat4.xz = vec2(u_xlat25) + vec2(1.0, -1.0);
					    u_xlat25 = (u_xlatb27) ? u_xlat4.z : u_xlat25;
					    u_xlat25 = (u_xlatb26) ? u_xlat4.x : u_xlat25;
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat13.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat13.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat25 = _scalar_intNormal;
					    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat25 * u_xlat0.x + 1.0;
					    u_xlat10_21.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat25 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat25 = u_xlat10_21.x * u_xlat25 + _scalar_minrg;
					    u_xlat25 = (-u_xlat25) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat5.yyy;
					    u_xlat8.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat8.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat8.xyz;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat24 = inversesqrt(u_xlat24);
					    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    u_xlatb1 = unity_ProbeVolumeParams.x==0.0;
					    if(u_xlatb1){
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(unity_SHAr, u_xlat0);
					        u_xlat1.y = dot(unity_SHAg, u_xlat0);
					        u_xlat1.z = dot(unity_SHAb, u_xlat0);
					        u_xlat2 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat2);
					        u_xlat5.y = dot(unity_SHBg, u_xlat2);
					        u_xlat5.z = dot(unity_SHBb, u_xlat2);
					        u_xlat2.x = u_xlat0.y * u_xlat0.y;
					        u_xlat2.x = u_xlat0.x * u_xlat0.x + (-u_xlat2.x);
					        u_xlat2.xyz = unity_SHC.xyz * u_xlat2.xxx + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat2.xyz;
					    } else {
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb26 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					        u_xlat2.xyz = (bool(u_xlatb26)) ? u_xlat2.xyz : vs_TEXCOORD0.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat2.yzw = u_xlat2.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat10 = u_xlat2.y * 0.25;
					        u_xlat27 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat12 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat10 = max(u_xlat10, u_xlat27);
					        u_xlat2.x = min(u_xlat12, u_xlat10);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat2.xzw, 0.0);
					        u_xlat5.xyz = u_xlat2.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat2.xyz = u_xlat2.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_2 = textureLod(unity_ProbeVolumeSH, u_xlat2.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(u_xlat10_6, u_xlat0);
					        u_xlat1.y = dot(u_xlat10_7, u_xlat0);
					        u_xlat1.z = dot(u_xlat10_2, u_xlat0);
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat25) + 1.0;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat24 = max(u_xlat24, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat24);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_24 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_24 = u_xlat10_24 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_24);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat24 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb25 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb25) ? u_xlat24 : (-u_xlat24);
					    u_xlat24 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat24 = float(1.0) / float(u_xlat24);
					    u_xlat2.xzw = vec3(u_xlat24) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb18.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb18.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb18.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat24) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu16.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu16.y * 16u + u_xlatu16.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_21.yyy * u_xlat1.xyz;
					    u_xlat24 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat24 = u_xlat24 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_LightmapInd;
					layout(location = 5) uniform  sampler2D unity_ShadowMask;
					layout(location = 6) uniform  sampler2D _ExposureTexture;
					layout(location = 7) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 8) uniform  sampler2D _texture2D_color;
					layout(location = 9) uniform  sampler2D _texture2D_normal;
					layout(location = 10) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec2 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					vec3 u_xlat16_3;
					vec4 u_xlat10_3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					vec3 u_xlat10_6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat2.xz = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat2.xz = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_3 = texture(unity_LightmapInd, u_xlat2.xz);
					    u_xlat16_3.xyz = u_xlat10_3.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_15 = max(u_xlat10_3.w, 9.99999975e-05);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat16_3.xyz);
					    u_xlat1.x = u_xlat1.x + 0.5;
					    u_xlat10_6.xyz = texture(unity_Lightmap, u_xlat2.xz).xyz;
					    SV_Target4 = texture(unity_ShadowMask, u_xlat2.xz);
					    u_xlat1.xyz = u_xlat1.xxx * u_xlat10_6.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat16_15);
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_LightmapInd;
					layout(location = 5) uniform  sampler2D unity_ShadowMask;
					layout(location = 6) uniform  sampler2D _ExposureTexture;
					layout(location = 7) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 8) uniform  sampler2D _texture2D_color;
					layout(location = 9) uniform  sampler2D _texture2D_normal;
					layout(location = 10) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec2 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					vec3 u_xlat16_3;
					vec4 u_xlat10_3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					vec3 u_xlat10_6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat2.xz = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat2.xz = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_3 = texture(unity_LightmapInd, u_xlat2.xz);
					    u_xlat16_3.xyz = u_xlat10_3.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_15 = max(u_xlat10_3.w, 9.99999975e-05);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat16_3.xyz);
					    u_xlat1.x = u_xlat1.x + 0.5;
					    u_xlat10_6.xyz = texture(unity_Lightmap, u_xlat2.xz).xyz;
					    SV_Target4 = texture(unity_ShadowMask, u_xlat2.xz);
					    u_xlat1.xyz = u_xlat1.xxx * u_xlat10_6.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat16_15);
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_LightmapInd;
					layout(location = 5) uniform  sampler2D unity_ShadowMask;
					layout(location = 6) uniform  sampler2D _ExposureTexture;
					layout(location = 7) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 8) uniform  sampler2D _texture2D_color;
					layout(location = 9) uniform  sampler2D _texture2D_normal;
					layout(location = 10) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec2 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					vec3 u_xlat16_3;
					vec4 u_xlat10_3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat6;
					vec3 u_xlat10_6;
					bvec2 u_xlatb7;
					float u_xlat10;
					bool u_xlatb10;
					vec2 u_xlat12;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					float u_xlat16;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlatb15 = 0.0<vs_TEXCOORD2.w;
					    u_xlat15 = (u_xlatb15) ? 1.0 : -1.0;
					    u_xlat15 = u_xlat15 * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = float(1.0) / u_xlat15;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat2.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat2.x = u_xlat2.x * u_xlat2.z;
					    u_xlat2.xy = u_xlat2.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat12.xy = u_xlat2.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat16 = dot(u_xlat2.xy, u_xlat2.xy);
					    u_xlat16 = min(u_xlat16, 1.0);
					    u_xlat16 = (-u_xlat16) + 1.0;
					    u_xlat16 = sqrt(u_xlat16);
					    u_xlat16 = u_xlat16 + -1.0;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat12.yyy;
					    u_xlat2.xyw = vec3(u_xlat15) * vs_TEXCOORD2.xyz;
					    u_xlat3.xyz = vec3(u_xlat15) * vs_TEXCOORD1.xyz;
					    u_xlat1.xyz = u_xlat12.xxx * u_xlat2.xyw + u_xlat1.xyz;
					    u_xlat15 = _scalar_intNormal;
					    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
					    u_xlat15 = u_xlat15 * u_xlat16 + 1.0;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat3.xyz + u_xlat1.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat2.xz = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat2.xz = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_3 = texture(unity_LightmapInd, u_xlat2.xz);
					    u_xlat16_3.xyz = u_xlat10_3.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_15 = max(u_xlat10_3.w, 9.99999975e-05);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat16_3.xyz);
					    u_xlat1.x = u_xlat1.x + 0.5;
					    u_xlat10_6.xyz = texture(unity_Lightmap, u_xlat2.xz).xyz;
					    SV_Target4 = texture(unity_ShadowMask, u_xlat2.xz);
					    u_xlat1.xyz = u_xlat1.xxx * u_xlat10_6.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat16_15);
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_LightmapInd;
					layout(location = 5) uniform  sampler2D _ExposureTexture;
					layout(location = 6) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 7) uniform  sampler2D _texture2D_color;
					layout(location = 8) uniform  sampler2D _texture2D_normal;
					layout(location = 9) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					vec3 u_xlat16_3;
					vec4 u_xlat10_3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat2.xz = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat2.xz = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_3 = texture(unity_LightmapInd, u_xlat2.xz);
					    u_xlat10_2.xzw = texture(unity_Lightmap, u_xlat2.xz).xyz;
					    u_xlat16_3.xyz = u_xlat10_3.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_15 = max(u_xlat10_3.w, 9.99999975e-05);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat16_3.xyz);
					    u_xlat1.x = u_xlat1.x + 0.5;
					    u_xlat1.xyz = u_xlat1.xxx * u_xlat10_2.xzw;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat16_15);
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_LightmapInd;
					layout(location = 5) uniform  sampler2D _ExposureTexture;
					layout(location = 6) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 7) uniform  sampler2D _texture2D_color;
					layout(location = 8) uniform  sampler2D _texture2D_normal;
					layout(location = 9) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					vec3 u_xlat16_3;
					vec4 u_xlat10_3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat2.xz = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat2.xz = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_3 = texture(unity_LightmapInd, u_xlat2.xz);
					    u_xlat10_2.xzw = texture(unity_Lightmap, u_xlat2.xz).xyz;
					    u_xlat16_3.xyz = u_xlat10_3.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_15 = max(u_xlat10_3.w, 9.99999975e-05);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat16_3.xyz);
					    u_xlat1.x = u_xlat1.x + 0.5;
					    u_xlat1.xyz = u_xlat1.xxx * u_xlat10_2.xzw;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat16_15);
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_LightmapInd;
					layout(location = 5) uniform  sampler2D _ExposureTexture;
					layout(location = 6) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 7) uniform  sampler2D _texture2D_color;
					layout(location = 8) uniform  sampler2D _texture2D_normal;
					layout(location = 9) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					vec3 u_xlat16_3;
					vec4 u_xlat10_3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat6;
					bvec2 u_xlatb7;
					float u_xlat10;
					bool u_xlatb10;
					vec2 u_xlat12;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					float u_xlat16;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlatb15 = 0.0<vs_TEXCOORD2.w;
					    u_xlat15 = (u_xlatb15) ? 1.0 : -1.0;
					    u_xlat15 = u_xlat15 * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = float(1.0) / u_xlat15;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat2.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat2.x = u_xlat2.x * u_xlat2.z;
					    u_xlat2.xy = u_xlat2.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat12.xy = u_xlat2.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat16 = dot(u_xlat2.xy, u_xlat2.xy);
					    u_xlat16 = min(u_xlat16, 1.0);
					    u_xlat16 = (-u_xlat16) + 1.0;
					    u_xlat16 = sqrt(u_xlat16);
					    u_xlat16 = u_xlat16 + -1.0;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat12.yyy;
					    u_xlat2.xyw = vec3(u_xlat15) * vs_TEXCOORD2.xyz;
					    u_xlat3.xyz = vec3(u_xlat15) * vs_TEXCOORD1.xyz;
					    u_xlat1.xyz = u_xlat12.xxx * u_xlat2.xyw + u_xlat1.xyz;
					    u_xlat15 = _scalar_intNormal;
					    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
					    u_xlat15 = u_xlat15 * u_xlat16 + 1.0;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat3.xyz + u_xlat1.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat2.xz = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat2.xz = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_3 = texture(unity_LightmapInd, u_xlat2.xz);
					    u_xlat10_2.xzw = texture(unity_Lightmap, u_xlat2.xz).xyz;
					    u_xlat16_3.xyz = u_xlat10_3.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_15 = max(u_xlat10_3.w, 9.99999975e-05);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat16_3.xyz);
					    u_xlat1.x = u_xlat1.x + 0.5;
					    u_xlat1.xyz = u_xlat1.xxx * u_xlat10_2.xzw;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat16_15);
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_ShadowMask;
					layout(location = 5) uniform  sampler2D _ExposureTexture;
					layout(location = 6) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 7) uniform  sampler2D _texture2D_color;
					layout(location = 8) uniform  sampler2D _texture2D_normal;
					layout(location = 9) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat1.xy = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat1.xy, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat1.xy = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_2.xzw = texture(unity_Lightmap, u_xlat1.xy).xyz;
					    SV_Target4 = texture(unity_ShadowMask, u_xlat1.xy);
					    u_xlat1.xyz = u_xlat10_2.xzw * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_ShadowMask;
					layout(location = 5) uniform  sampler2D _ExposureTexture;
					layout(location = 6) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 7) uniform  sampler2D _texture2D_color;
					layout(location = 8) uniform  sampler2D _texture2D_normal;
					layout(location = 9) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat1.xy = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat1.xy, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat1.xy = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_2.xzw = texture(unity_Lightmap, u_xlat1.xy).xyz;
					    SV_Target4 = texture(unity_ShadowMask, u_xlat1.xy);
					    u_xlat1.xyz = u_xlat10_2.xzw * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "SHADOWS_SHADOWMASK" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D unity_ShadowMask;
					layout(location = 5) uniform  sampler2D _ExposureTexture;
					layout(location = 6) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 7) uniform  sampler2D _texture2D_color;
					layout(location = 8) uniform  sampler2D _texture2D_normal;
					layout(location = 9) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat6;
					bvec2 u_xlatb7;
					float u_xlat10;
					bool u_xlatb10;
					vec2 u_xlat12;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					float u_xlat16;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlatb15 = 0.0<vs_TEXCOORD2.w;
					    u_xlat15 = (u_xlatb15) ? 1.0 : -1.0;
					    u_xlat15 = u_xlat15 * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = float(1.0) / u_xlat15;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat2.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat2.x = u_xlat2.x * u_xlat2.z;
					    u_xlat2.xy = u_xlat2.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat12.xy = u_xlat2.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat16 = dot(u_xlat2.xy, u_xlat2.xy);
					    u_xlat16 = min(u_xlat16, 1.0);
					    u_xlat16 = (-u_xlat16) + 1.0;
					    u_xlat16 = sqrt(u_xlat16);
					    u_xlat16 = u_xlat16 + -1.0;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat12.yyy;
					    u_xlat2.xyw = vec3(u_xlat15) * vs_TEXCOORD2.xyz;
					    u_xlat3.xyz = vec3(u_xlat15) * vs_TEXCOORD1.xyz;
					    u_xlat1.xyz = u_xlat12.xxx * u_xlat2.xyw + u_xlat1.xyz;
					    u_xlat15 = _scalar_intNormal;
					    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
					    u_xlat15 = u_xlat15 * u_xlat16 + 1.0;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat3.xyz + u_xlat1.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat1.xy = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat1.xy, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat1.xy = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_2.xzw = texture(unity_Lightmap, u_xlat1.xy).xyz;
					    SV_Target4 = texture(unity_ShadowMask, u_xlat1.xy);
					    u_xlat1.xyz = u_xlat10_2.xzw * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec3 u_xlat10_1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec2 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat1.xy = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat1.xy, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat1.xy = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_1.xyz = texture(unity_Lightmap, u_xlat1.xy).xyz;
					    u_xlat1.xyz = u_xlat10_1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec3 u_xlat10_1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec2 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec3 u_xlat6;
					bvec2 u_xlatb7;
					vec3 u_xlat8;
					float u_xlat10;
					bool u_xlatb10;
					float u_xlat11;
					bool u_xlatb11;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlat1.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat1.xy = u_xlat1.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = u_xlat15 + -1.0;
					    u_xlat11 = _scalar_intNormal;
					    u_xlat11 = clamp(u_xlat11, 0.0, 1.0);
					    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
					    u_xlatb11 = 0.0<vs_TEXCOORD2.w;
					    u_xlat11 = (u_xlatb11) ? 1.0 : -1.0;
					    u_xlat11 = u_xlat11 * unity_WorldTransformParams.w;
					    u_xlat2.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat2.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat2.xyz);
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat11 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat11 = sqrt(u_xlat11);
					    u_xlat11 = max(u_xlat11, 1.17549435e-38);
					    u_xlat11 = float(1.0) / u_xlat11;
					    u_xlat2.xyz = vec3(u_xlat11) * u_xlat2.xyz;
					    u_xlat3.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat1.xy = u_xlat1.xy * u_xlat3.yy;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat1.yyy;
					    u_xlat8.xyz = vec3(u_xlat11) * vs_TEXCOORD2.xyz;
					    u_xlat6.xyz = vec3(u_xlat11) * vs_TEXCOORD1.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * u_xlat3.xxx;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat8.xyz + u_xlat2.xyz;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz + u_xlat2.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat1.xy = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat1.xy, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat1.xy = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_1.xyz = texture(unity_Lightmap, u_xlat1.xy).xyz;
					    u_xlat1.xyz = u_xlat10_1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "LIGHTMAP_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2;
						vec4 unity_LightmapST;
						vec4 unused_0_4[25];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[43];
						vec4 unity_OrthoParams;
						vec4 unused_1_3[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_5[88];
						float _ProbeExposureScale;
						vec4 unused_1_7;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler2D unity_Lightmap;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 4) in  vec4 vs_TEXCOORD4;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec3 u_xlat10_1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec2 u_xlat10_2;
					uvec2 u_xlatu2;
					bool u_xlatb2;
					vec3 u_xlat3;
					bool u_xlatb3;
					vec3 u_xlat4;
					vec3 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat6;
					bvec2 u_xlatb7;
					float u_xlat10;
					bool u_xlatb10;
					vec2 u_xlat12;
					uvec2 u_xlatu12;
					float u_xlat15;
					float u_xlat16_15;
					float u_xlat10_15;
					uint u_xlatu15;
					bool u_xlatb15;
					float u_xlat16;
					void main()
					{
					    u_xlat0.z = float(-1.0);
					    u_xlat0.w = float(0.666666687);
					    u_xlat1.z = float(1.0);
					    u_xlat1.w = float(-1.0);
					    u_xlat2.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb3 = u_xlat2.x>=u_xlat2.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat0.xy = u_xlat2.yx;
					    u_xlat1.xy = (-u_xlat0.xy) + u_xlat2.xy;
					    u_xlat0 = u_xlat3.xxxx * u_xlat1 + u_xlat0;
					    u_xlat2.xyz = u_xlat0.xyw;
					    u_xlatb1 = u_xlat2.w>=u_xlat2.x;
					    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
					    u_xlat0.xyw = u_xlat2.wyx;
					    u_xlat0 = u_xlat0 + (-u_xlat2);
					    u_xlat0 = u_xlat1.xxxx * u_xlat0 + u_xlat2;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlatb10 = 1.0<abs(u_xlat5.x);
					    u_xlat15 = abs(u_xlat5.x) + -1.0;
					    u_xlat5.x = (u_xlatb10) ? u_xlat15 : abs(u_xlat5.x);
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyw = u_xlat5.yzx * u_xlat0.xxx;
					    u_xlat2.xy = u_xlat1.yx;
					    u_xlat0.xy = u_xlat0.xx * u_xlat5.yz + (-u_xlat2.xy);
					    u_xlatb3 = u_xlat2.y>=u_xlat1.y;
					    u_xlat3.x = u_xlatb3 ? 1.0 : float(0.0);
					    u_xlat2.z = float(-1.0);
					    u_xlat2.w = float(0.666666687);
					    u_xlat0.z = float(1.0);
					    u_xlat0.w = float(-1.0);
					    u_xlat0 = u_xlat3.xxxx * u_xlat0 + u_xlat2;
					    u_xlatb2 = u_xlat1.w>=u_xlat0.x;
					    u_xlat2.x = u_xlatb2 ? 1.0 : float(0.0);
					    u_xlat1.xyz = u_xlat0.xyw;
					    u_xlat0.xyw = u_xlat1.wyx;
					    u_xlat0 = (-u_xlat1) + u_xlat0;
					    u_xlat0 = u_xlat2.xxxx * u_xlat0 + u_xlat1;
					    u_xlat1.x = min(u_xlat0.y, u_xlat0.w);
					    u_xlat1.x = u_xlat0.x + (-u_xlat1.x);
					    u_xlat6.x = u_xlat1.x * 6.0 + 9.99999975e-05;
					    u_xlat5.x = (-u_xlat0.y) + u_xlat0.w;
					    u_xlat5.x = u_xlat5.x / u_xlat6.x;
					    u_xlat5.x = u_xlat5.x + u_xlat0.z;
					    u_xlat5.x = abs(u_xlat5.x) + _scalar_hueshift;
					    u_xlatb10 = 1.0<u_xlat5.x;
					    u_xlat6.xy = u_xlat5.xx + vec2(1.0, -1.0);
					    u_xlat10 = (u_xlatb10) ? u_xlat6.y : u_xlat5.x;
					    u_xlatb5 = u_xlat5.x<0.0;
					    u_xlat5.x = (u_xlatb5) ? u_xlat6.x : u_xlat10;
					    u_xlat5.xyz = u_xlat5.xxx + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat5.xyz = fract(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat5.xyz = abs(u_xlat5.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
					    u_xlat5.xyz = u_xlat5.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat6.x = u_xlat0.x + 9.99999975e-05;
					    u_xlat1.x = u_xlat1.x / u_xlat6.x;
					    u_xlat5.xyz = u_xlat1.xxx * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat5.xyz * u_xlat0.xxx;
					    u_xlat1.x = dot(u_xlat1.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat5.xyz + (-u_xlat1.xxx);
					    u_xlat0.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat0.xyz + u_xlat1.xxx;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    u_xlatb15 = 0.0<vs_TEXCOORD2.w;
					    u_xlat15 = (u_xlatb15) ? 1.0 : -1.0;
					    u_xlat15 = u_xlat15 * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat15 = sqrt(u_xlat15);
					    u_xlat15 = max(u_xlat15, 1.17549435e-38);
					    u_xlat15 = float(1.0) / u_xlat15;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat2.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat2.x = u_xlat2.x * u_xlat2.z;
					    u_xlat2.xy = u_xlat2.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat12.xy = u_xlat2.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat16 = dot(u_xlat2.xy, u_xlat2.xy);
					    u_xlat16 = min(u_xlat16, 1.0);
					    u_xlat16 = (-u_xlat16) + 1.0;
					    u_xlat16 = sqrt(u_xlat16);
					    u_xlat16 = u_xlat16 + -1.0;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat12.yyy;
					    u_xlat2.xyw = vec3(u_xlat15) * vs_TEXCOORD2.xyz;
					    u_xlat3.xyz = vec3(u_xlat15) * vs_TEXCOORD1.xyz;
					    u_xlat1.xyz = u_xlat12.xxx * u_xlat2.xyw + u_xlat1.xyz;
					    u_xlat15 = _scalar_intNormal;
					    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
					    u_xlat15 = u_xlat15 * u_xlat16 + 1.0;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat3.xyz + u_xlat1.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat1.xyz;
					    u_xlat15 = max(abs(u_xlat1.z), 0.0009765625);
					    u_xlatb2 = u_xlat1.z>=0.0;
					    u_xlat1.w = (u_xlatb2) ? u_xlat15 : (-u_xlat15);
					    u_xlat15 = dot(abs(u_xlat1.xyw), vec3(1.0, 1.0, 1.0));
					    u_xlat15 = float(1.0) / float(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat1.wxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb7.xy = greaterThanEqual(u_xlat2.yzyy, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb7.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.y = (u_xlatb7.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat2.xy = u_xlat1.xy * vec2(u_xlat15) + u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					    u_xlat2.xy = u_xlat2.xy * vec2(4095.5, 4095.5);
					    u_xlatu2.xy = uvec2(u_xlat2.xy);
					    u_xlatu12.xy = u_xlatu2.xy >> uvec2(8u, 8u);
					    u_xlatu2.xy = u_xlatu2.xy & uvec2(255u, 255u);
					    u_xlat3.xy = vec2(u_xlatu2.xy);
					    u_xlatu15 = u_xlatu12.y * 16u + u_xlatu12.x;
					    u_xlat3.z = float(u_xlatu15);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat15 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat10_2.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat15 = u_xlat10_2.x * u_xlat15 + _scalar_minrg;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat3.y = (-u_xlat15) + 1.0;
					    SV_Target1.w = u_xlat3.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    u_xlatb15 = unity_OrthoParams.w==0.0;
					    u_xlat4.x = (u_xlatb15) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat4.y = (u_xlatb15) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat4.z = (u_xlatb15) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xzw = vec3(u_xlat15) * u_xlat4.xyz;
					    u_xlat15 = dot(u_xlat1.xyz, u_xlat2.xzw);
					    u_xlat15 = max(u_xlat15, 9.99999975e-05);
					    u_xlat3.x = sqrt(u_xlat15);
					    u_xlat1.xy = u_xlat3.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_15 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat1.xy, 0.0).z;
					    u_xlat16_15 = u_xlat10_15 + 0.5;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat16_15);
					    u_xlat1.xy = vs_TEXCOORD4.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat10_1.xyz = texture(unity_Lightmap, u_xlat1.xy).xyz;
					    u_xlat1.xyz = u_xlat10_1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat10_2.yyy * u_xlat0.xyz;
					    u_xlat15 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat15 = u_xlat15 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unity_ProbesOcclusion;
						vec4 unused_0_15[9];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bvec2 u_xlatb1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec4 u_xlat10_8;
					vec3 u_xlat9;
					bool u_xlatb9;
					vec3 u_xlat14;
					uvec2 u_xlatu18;
					float u_xlat19;
					bvec2 u_xlatb20;
					vec2 u_xlat10_23;
					float u_xlat27;
					float u_xlat16_27;
					float u_xlat10_27;
					bool u_xlatb27;
					float u_xlat28;
					bool u_xlatb28;
					float u_xlat29;
					bool u_xlatb29;
					float u_xlat30;
					bool u_xlatb30;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb9 = 0.0<vs_TEXCOORD2.w;
					    u_xlat9.x = (u_xlatb9) ? 1.0 : -1.0;
					    u_xlat9.x = u_xlat9.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat9.xyz = u_xlat9.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat9.xyz = u_xlat0.xxx * u_xlat9.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlatb29 = 1.0<abs(u_xlat28);
					    u_xlat30 = abs(u_xlat28) + -1.0;
					    u_xlat28 = (u_xlatb29) ? u_xlat30 : abs(u_xlat28);
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlat28 = abs(u_xlat28) + _scalar_hueshift;
					    u_xlatb29 = u_xlat28<0.0;
					    u_xlatb30 = 1.0<u_xlat28;
					    u_xlat4.xz = vec2(u_xlat28) + vec2(1.0, -1.0);
					    u_xlat28 = (u_xlatb30) ? u_xlat4.z : u_xlat28;
					    u_xlat28 = (u_xlatb29) ? u_xlat4.x : u_xlat28;
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat14.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat14.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat28 = _scalar_intNormal;
					    u_xlat28 = clamp(u_xlat28, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat28 * u_xlat0.x + 1.0;
					    u_xlat10_23.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat28 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat28 = u_xlat10_23.x * u_xlat28 + _scalar_minrg;
					    u_xlat28 = (-u_xlat28) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat9.xyz = u_xlat9.xyz * u_xlat5.yyy;
					    u_xlat9.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat9.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat9.xyz;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat27 = inversesqrt(u_xlat27);
					    u_xlat0.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    u_xlatb1.xy = equal(unity_ProbeVolumeParams.xxxx, vec4(0.0, 1.0, 0.0, 0.0)).xy;
					    if(u_xlatb1.x){
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(unity_SHAr, u_xlat0);
					        u_xlat2.y = dot(unity_SHAg, u_xlat0);
					        u_xlat2.z = dot(unity_SHAb, u_xlat0);
					        u_xlat6 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat6);
					        u_xlat5.y = dot(unity_SHBg, u_xlat6);
					        u_xlat5.z = dot(unity_SHBb, u_xlat6);
					        u_xlat1.x = u_xlat0.y * u_xlat0.y;
					        u_xlat1.x = u_xlat0.x * u_xlat0.x + (-u_xlat1.x);
					        u_xlat5.xyz = unity_SHC.xyz * u_xlat1.xxx + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					    } else {
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb1.x = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat6.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + u_xlat6.xyz;
					        u_xlat5.xyz = (u_xlatb1.x) ? u_xlat5.xyz : vs_TEXCOORD0.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat1.x = u_xlat6.y * 0.25;
					        u_xlat19 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat29 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat1.x = max(u_xlat19, u_xlat1.x);
					        u_xlat6.x = min(u_xlat29, u_xlat1.x);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat6.xzw, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_8 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(u_xlat10_7, u_xlat0);
					        u_xlat2.y = dot(u_xlat10_8, u_xlat0);
					        u_xlat2.z = dot(u_xlat10_6, u_xlat0);
					    //ENDIF
					    }
					    if(u_xlatb1.y){
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat1.xyz;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat1.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb27 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat5.xyz;
					        u_xlat1.xyz = (bool(u_xlatb27)) ? u_xlat1.xyz : vs_TEXCOORD0.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat1.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat27 = u_xlat6.y * 0.25 + 0.75;
					        u_xlat1.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
					        u_xlat6.x = max(u_xlat27, u_xlat1.x);
					        SV_Target4 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					    } else {
					        SV_Target4 = unity_ProbesOcclusion;
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat2.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat28) + 1.0;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat27 = max(u_xlat27, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat27);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_27 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_27 = u_xlat10_27 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_27);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat27 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb28 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb28) ? u_xlat27 : (-u_xlat27);
					    u_xlat27 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat27 = float(1.0) / float(u_xlat27);
					    u_xlat2.xzw = vec3(u_xlat27) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb20.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb20.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb20.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat27) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu18.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu18.y * 16u + u_xlatu18.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_23.yyy * u_xlat1.xyz;
					    u_xlat27 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat27 = u_xlat27 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unity_ProbesOcclusion;
						vec4 unused_0_15[9];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bvec2 u_xlatb1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec4 u_xlat10_8;
					vec3 u_xlat9;
					bool u_xlatb9;
					vec3 u_xlat14;
					uvec2 u_xlatu18;
					float u_xlat19;
					bvec2 u_xlatb20;
					vec2 u_xlat10_23;
					float u_xlat27;
					float u_xlat16_27;
					float u_xlat10_27;
					bool u_xlatb27;
					float u_xlat28;
					bool u_xlatb28;
					float u_xlat29;
					bool u_xlatb29;
					float u_xlat30;
					bool u_xlatb30;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb9 = 0.0<vs_TEXCOORD2.w;
					    u_xlat9.x = (u_xlatb9) ? 1.0 : -1.0;
					    u_xlat9.x = u_xlat9.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat9.xyz = u_xlat9.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat9.xyz = u_xlat0.xxx * u_xlat9.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlatb29 = 1.0<abs(u_xlat28);
					    u_xlat30 = abs(u_xlat28) + -1.0;
					    u_xlat28 = (u_xlatb29) ? u_xlat30 : abs(u_xlat28);
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlat28 = abs(u_xlat28) + _scalar_hueshift;
					    u_xlatb29 = u_xlat28<0.0;
					    u_xlatb30 = 1.0<u_xlat28;
					    u_xlat4.xz = vec2(u_xlat28) + vec2(1.0, -1.0);
					    u_xlat28 = (u_xlatb30) ? u_xlat4.z : u_xlat28;
					    u_xlat28 = (u_xlatb29) ? u_xlat4.x : u_xlat28;
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat14.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat14.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat28 = _scalar_intNormal;
					    u_xlat28 = clamp(u_xlat28, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat28 * u_xlat0.x + 1.0;
					    u_xlat10_23.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat28 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat28 = u_xlat10_23.x * u_xlat28 + _scalar_minrg;
					    u_xlat28 = (-u_xlat28) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat9.xyz = u_xlat9.xyz * u_xlat5.yyy;
					    u_xlat9.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat9.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat9.xyz;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat27 = inversesqrt(u_xlat27);
					    u_xlat0.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    u_xlatb1.xy = equal(unity_ProbeVolumeParams.xxxx, vec4(0.0, 1.0, 0.0, 0.0)).xy;
					    if(u_xlatb1.x){
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(unity_SHAr, u_xlat0);
					        u_xlat2.y = dot(unity_SHAg, u_xlat0);
					        u_xlat2.z = dot(unity_SHAb, u_xlat0);
					        u_xlat6 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat6);
					        u_xlat5.y = dot(unity_SHBg, u_xlat6);
					        u_xlat5.z = dot(unity_SHBb, u_xlat6);
					        u_xlat1.x = u_xlat0.y * u_xlat0.y;
					        u_xlat1.x = u_xlat0.x * u_xlat0.x + (-u_xlat1.x);
					        u_xlat5.xyz = unity_SHC.xyz * u_xlat1.xxx + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					    } else {
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb1.x = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat6.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + u_xlat6.xyz;
					        u_xlat5.xyz = (u_xlatb1.x) ? u_xlat5.xyz : vs_TEXCOORD0.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat1.x = u_xlat6.y * 0.25;
					        u_xlat19 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat29 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat1.x = max(u_xlat19, u_xlat1.x);
					        u_xlat6.x = min(u_xlat29, u_xlat1.x);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat6.xzw, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_8 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(u_xlat10_7, u_xlat0);
					        u_xlat2.y = dot(u_xlat10_8, u_xlat0);
					        u_xlat2.z = dot(u_xlat10_6, u_xlat0);
					    //ENDIF
					    }
					    if(u_xlatb1.y){
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat1.xyz;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat1.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb27 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat5.xyz;
					        u_xlat1.xyz = (bool(u_xlatb27)) ? u_xlat1.xyz : vs_TEXCOORD0.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat1.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat27 = u_xlat6.y * 0.25 + 0.75;
					        u_xlat1.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
					        u_xlat6.x = max(u_xlat27, u_xlat1.x);
					        SV_Target4 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					    } else {
					        SV_Target4 = unity_ProbesOcclusion;
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat2.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat28) + 1.0;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat27 = max(u_xlat27, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat27);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_27 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_27 = u_xlat10_27 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_27);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat27 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb28 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb28) ? u_xlat27 : (-u_xlat27);
					    u_xlat27 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat27 = float(1.0) / float(u_xlat27);
					    u_xlat2.xzw = vec3(u_xlat27) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb20.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb20.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb20.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat27) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu18.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu18.y * 16u + u_xlatu18.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_23.yyy * u_xlat1.xyz;
					    u_xlat27 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat27 = u_xlat27 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "SHADOWS_SHADOWMASK" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unity_ProbesOcclusion;
						vec4 unused_0_15[9];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bvec2 u_xlatb1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat10_7;
					vec4 u_xlat10_8;
					vec3 u_xlat9;
					bool u_xlatb9;
					vec3 u_xlat13;
					uvec2 u_xlatu18;
					float u_xlat19;
					bvec2 u_xlatb20;
					vec2 u_xlat10_23;
					float u_xlat27;
					float u_xlat16_27;
					float u_xlat10_27;
					bool u_xlatb27;
					float u_xlat28;
					bool u_xlatb28;
					float u_xlat29;
					bool u_xlatb29;
					float u_xlat30;
					bool u_xlatb30;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb9 = 0.0<vs_TEXCOORD2.w;
					    u_xlat9.x = (u_xlatb9) ? 1.0 : -1.0;
					    u_xlat9.x = u_xlat9.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat9.xyz = u_xlat9.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat9.xyz = u_xlat0.xxx * u_xlat9.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat4.x>=u_xlat4.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xy = u_xlat4.yx;
					    u_xlat5.z = float(-1.0);
					    u_xlat5.w = float(0.666666687);
					    u_xlat6.xy = u_xlat4.xy + (-u_xlat5.xy);
					    u_xlat6.z = float(1.0);
					    u_xlat6.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlatb0 = u_xlat4.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat4.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat4.wyx;
					    u_xlat5 = (-u_xlat4) + u_xlat5;
					    u_xlat4 = u_xlat0.xxxx * u_xlat5 + u_xlat4;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat28 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat4.z;
					    u_xlat29 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlatb29 = 1.0<abs(u_xlat28);
					    u_xlat30 = abs(u_xlat28) + -1.0;
					    u_xlat28 = (u_xlatb29) ? u_xlat30 : abs(u_xlat28);
					    u_xlat13.xyz = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat13.xyz = fract(u_xlat13.xyz);
					    u_xlat13.xyz = u_xlat13.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat13.xyz = abs(u_xlat13.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = clamp(u_xlat13.xyz, 0.0, 1.0);
					    u_xlat13.xyz = u_xlat13.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = u_xlat0.xxx * u_xlat13.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyw = u_xlat13.yzx * u_xlat4.xxx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat4.xy = u_xlat4.xx * u_xlat13.yz + (-u_xlat6.xy);
					    u_xlat4.z = float(1.0);
					    u_xlat4.w = float(-1.0);
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat4.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat4.xyw;
					    u_xlat4.xyw = u_xlat5.wyx;
					    u_xlat4 = (-u_xlat5) + u_xlat4;
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat5;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat28 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat4.z;
					    u_xlat29 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlat28 = abs(u_xlat28) + _scalar_hueshift;
					    u_xlatb29 = u_xlat28<0.0;
					    u_xlatb30 = 1.0<u_xlat28;
					    u_xlat13.xy = vec2(u_xlat28) + vec2(1.0, -1.0);
					    u_xlat28 = (u_xlatb30) ? u_xlat13.y : u_xlat28;
					    u_xlat28 = (u_xlatb29) ? u_xlat13.x : u_xlat28;
					    u_xlat13.xyz = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat13.xyz = fract(u_xlat13.xyz);
					    u_xlat13.xyz = u_xlat13.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat13.xyz = abs(u_xlat13.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = clamp(u_xlat13.xyz, 0.0, 1.0);
					    u_xlat13.xyz = u_xlat13.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = u_xlat0.xxx * u_xlat13.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyz = u_xlat13.xyz * u_xlat4.xxx;
					    u_xlat0.x = dot(u_xlat5.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xyz = u_xlat4.xxx * u_xlat13.xyz + (-u_xlat0.xxx);
					    u_xlat4.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xyz + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat28 = _scalar_intNormal;
					    u_xlat28 = clamp(u_xlat28, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat28 * u_xlat0.x + 1.0;
					    u_xlat10_23.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat28 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat28 = u_xlat10_23.x * u_xlat28 + _scalar_minrg;
					    u_xlat28 = (-u_xlat28) + 1.0;
					    u_xlat9.xyz = u_xlat9.xyz * u_xlat5.yyy;
					    u_xlat9.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat9.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat9.xyz;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat27 = inversesqrt(u_xlat27);
					    u_xlat0.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    u_xlatb1.xy = equal(unity_ProbeVolumeParams.xxxx, vec4(0.0, 1.0, 0.0, 0.0)).xy;
					    if(u_xlatb1.x){
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(unity_SHAr, u_xlat0);
					        u_xlat2.y = dot(unity_SHAg, u_xlat0);
					        u_xlat2.z = dot(unity_SHAb, u_xlat0);
					        u_xlat6 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat6);
					        u_xlat5.y = dot(unity_SHBg, u_xlat6);
					        u_xlat5.z = dot(unity_SHBb, u_xlat6);
					        u_xlat1.x = u_xlat0.y * u_xlat0.y;
					        u_xlat1.x = u_xlat0.x * u_xlat0.x + (-u_xlat1.x);
					        u_xlat5.xyz = unity_SHC.xyz * u_xlat1.xxx + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					    } else {
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb1.x = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat6.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + u_xlat6.xyz;
					        u_xlat5.xyz = (u_xlatb1.x) ? u_xlat5.xyz : vs_TEXCOORD0.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat1.x = u_xlat6.y * 0.25;
					        u_xlat19 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat29 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat1.x = max(u_xlat19, u_xlat1.x);
					        u_xlat6.x = min(u_xlat29, u_xlat1.x);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat6.xzw, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_8 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(u_xlat10_7, u_xlat0);
					        u_xlat2.y = dot(u_xlat10_8, u_xlat0);
					        u_xlat2.z = dot(u_xlat10_6, u_xlat0);
					    //ENDIF
					    }
					    if(u_xlatb1.y){
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat1.xyz;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat1.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb27 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat5.xyz;
					        u_xlat1.xyz = (bool(u_xlatb27)) ? u_xlat1.xyz : vs_TEXCOORD0.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat1.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat27 = u_xlat6.y * 0.25 + 0.75;
					        u_xlat1.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
					        u_xlat6.x = max(u_xlat27, u_xlat1.x);
					        SV_Target4 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					    } else {
					        SV_Target4 = unity_ProbesOcclusion;
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat2.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat28) + 1.0;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat27 = max(u_xlat27, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat27);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_27 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_27 = u_xlat10_27 + 0.5;
					    u_xlat2.xzw = u_xlat4.xyz * vec3(u_xlat16_27);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat27 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb28 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb28) ? u_xlat27 : (-u_xlat27);
					    u_xlat27 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat27 = float(1.0) / float(u_xlat27);
					    u_xlat2.xzw = vec3(u_xlat27) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb20.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb20.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb20.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat27) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu18.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu18.y * 16u + u_xlatu18.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_23.yyy * u_xlat1.xyz;
					    u_xlat27 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat27 = u_xlat27 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xyz;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "SHADOWS_SHADOWMASK" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unity_ProbesOcclusion;
						vec4 unused_0_15[9];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bvec2 u_xlatb1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat10_7;
					vec4 u_xlat10_8;
					vec3 u_xlat9;
					bool u_xlatb9;
					vec3 u_xlat13;
					uvec2 u_xlatu18;
					float u_xlat19;
					bvec2 u_xlatb20;
					vec2 u_xlat10_23;
					float u_xlat27;
					float u_xlat16_27;
					float u_xlat10_27;
					bool u_xlatb27;
					float u_xlat28;
					bool u_xlatb28;
					float u_xlat29;
					bool u_xlatb29;
					float u_xlat30;
					bool u_xlatb30;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb9 = 0.0<vs_TEXCOORD2.w;
					    u_xlat9.x = (u_xlatb9) ? 1.0 : -1.0;
					    u_xlat9.x = u_xlat9.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat9.xyz = u_xlat9.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat9.xyz = u_xlat0.xxx * u_xlat9.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat4.x>=u_xlat4.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xy = u_xlat4.yx;
					    u_xlat5.z = float(-1.0);
					    u_xlat5.w = float(0.666666687);
					    u_xlat6.xy = u_xlat4.xy + (-u_xlat5.xy);
					    u_xlat6.z = float(1.0);
					    u_xlat6.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlatb0 = u_xlat4.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat4.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat4.wyx;
					    u_xlat5 = (-u_xlat4) + u_xlat5;
					    u_xlat4 = u_xlat0.xxxx * u_xlat5 + u_xlat4;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat28 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat4.z;
					    u_xlat29 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlatb29 = 1.0<abs(u_xlat28);
					    u_xlat30 = abs(u_xlat28) + -1.0;
					    u_xlat28 = (u_xlatb29) ? u_xlat30 : abs(u_xlat28);
					    u_xlat13.xyz = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat13.xyz = fract(u_xlat13.xyz);
					    u_xlat13.xyz = u_xlat13.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat13.xyz = abs(u_xlat13.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = clamp(u_xlat13.xyz, 0.0, 1.0);
					    u_xlat13.xyz = u_xlat13.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = u_xlat0.xxx * u_xlat13.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyw = u_xlat13.yzx * u_xlat4.xxx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat4.xy = u_xlat4.xx * u_xlat13.yz + (-u_xlat6.xy);
					    u_xlat4.z = float(1.0);
					    u_xlat4.w = float(-1.0);
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat4.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat4.xyw;
					    u_xlat4.xyw = u_xlat5.wyx;
					    u_xlat4 = (-u_xlat5) + u_xlat4;
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat5;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat28 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat4.z;
					    u_xlat29 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlat28 = abs(u_xlat28) + _scalar_hueshift;
					    u_xlatb29 = u_xlat28<0.0;
					    u_xlatb30 = 1.0<u_xlat28;
					    u_xlat13.xy = vec2(u_xlat28) + vec2(1.0, -1.0);
					    u_xlat28 = (u_xlatb30) ? u_xlat13.y : u_xlat28;
					    u_xlat28 = (u_xlatb29) ? u_xlat13.x : u_xlat28;
					    u_xlat13.xyz = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat13.xyz = fract(u_xlat13.xyz);
					    u_xlat13.xyz = u_xlat13.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat13.xyz = abs(u_xlat13.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = clamp(u_xlat13.xyz, 0.0, 1.0);
					    u_xlat13.xyz = u_xlat13.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat13.xyz = u_xlat0.xxx * u_xlat13.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyz = u_xlat13.xyz * u_xlat4.xxx;
					    u_xlat0.x = dot(u_xlat5.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xyz = u_xlat4.xxx * u_xlat13.xyz + (-u_xlat0.xxx);
					    u_xlat4.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xyz + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat28 = _scalar_intNormal;
					    u_xlat28 = clamp(u_xlat28, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat28 * u_xlat0.x + 1.0;
					    u_xlat10_23.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat28 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat28 = u_xlat10_23.x * u_xlat28 + _scalar_minrg;
					    u_xlat28 = (-u_xlat28) + 1.0;
					    u_xlat9.xyz = u_xlat9.xyz * u_xlat5.yyy;
					    u_xlat9.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat9.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat9.xyz;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat27 = inversesqrt(u_xlat27);
					    u_xlat0.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    u_xlatb1.xy = equal(unity_ProbeVolumeParams.xxxx, vec4(0.0, 1.0, 0.0, 0.0)).xy;
					    if(u_xlatb1.x){
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(unity_SHAr, u_xlat0);
					        u_xlat2.y = dot(unity_SHAg, u_xlat0);
					        u_xlat2.z = dot(unity_SHAb, u_xlat0);
					        u_xlat6 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat6);
					        u_xlat5.y = dot(unity_SHBg, u_xlat6);
					        u_xlat5.z = dot(unity_SHBb, u_xlat6);
					        u_xlat1.x = u_xlat0.y * u_xlat0.y;
					        u_xlat1.x = u_xlat0.x * u_xlat0.x + (-u_xlat1.x);
					        u_xlat5.xyz = unity_SHC.xyz * u_xlat1.xxx + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					    } else {
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb1.x = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat6.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + u_xlat6.xyz;
					        u_xlat5.xyz = (u_xlatb1.x) ? u_xlat5.xyz : vs_TEXCOORD0.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat1.x = u_xlat6.y * 0.25;
					        u_xlat19 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat29 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat1.x = max(u_xlat19, u_xlat1.x);
					        u_xlat6.x = min(u_xlat29, u_xlat1.x);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat6.xzw, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_8 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(u_xlat10_7, u_xlat0);
					        u_xlat2.y = dot(u_xlat10_8, u_xlat0);
					        u_xlat2.z = dot(u_xlat10_6, u_xlat0);
					    //ENDIF
					    }
					    if(u_xlatb1.y){
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat1.xyz;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat1.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb27 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat5.xyz;
					        u_xlat1.xyz = (bool(u_xlatb27)) ? u_xlat1.xyz : vs_TEXCOORD0.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat1.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat27 = u_xlat6.y * 0.25 + 0.75;
					        u_xlat1.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
					        u_xlat6.x = max(u_xlat27, u_xlat1.x);
					        SV_Target4 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					    } else {
					        SV_Target4 = unity_ProbesOcclusion;
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat2.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat28) + 1.0;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat27 = max(u_xlat27, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat27);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_27 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_27 = u_xlat10_27 + 0.5;
					    u_xlat2.xzw = u_xlat4.xyz * vec3(u_xlat16_27);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat27 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb28 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb28) ? u_xlat27 : (-u_xlat27);
					    u_xlat27 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat27 = float(1.0) / float(u_xlat27);
					    u_xlat2.xzw = vec3(u_xlat27) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb20.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb20.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb20.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat27) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu18.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu18.y * 16u + u_xlatu18.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_23.yyy * u_xlat1.xyz;
					    u_xlat27 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat27 = u_xlat27 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xyz;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "SHADOWS_SHADOWMASK" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unity_ProbesOcclusion;
						vec4 unused_0_15[9];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bvec2 u_xlatb1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec4 u_xlat10_8;
					vec3 u_xlat9;
					bool u_xlatb9;
					vec3 u_xlat14;
					uvec2 u_xlatu18;
					float u_xlat19;
					bvec2 u_xlatb20;
					vec2 u_xlat10_23;
					float u_xlat27;
					float u_xlat16_27;
					float u_xlat10_27;
					bool u_xlatb27;
					float u_xlat28;
					bool u_xlatb28;
					float u_xlat29;
					bool u_xlatb29;
					float u_xlat30;
					bool u_xlatb30;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb9 = 0.0<vs_TEXCOORD2.w;
					    u_xlat9.x = (u_xlatb9) ? 1.0 : -1.0;
					    u_xlat9.x = u_xlat9.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat9.xyz = u_xlat9.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat9.xyz = u_xlat0.xxx * u_xlat9.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlatb29 = 1.0<abs(u_xlat28);
					    u_xlat30 = abs(u_xlat28) + -1.0;
					    u_xlat28 = (u_xlatb29) ? u_xlat30 : abs(u_xlat28);
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlat28 = abs(u_xlat28) + _scalar_hueshift;
					    u_xlatb29 = u_xlat28<0.0;
					    u_xlatb30 = 1.0<u_xlat28;
					    u_xlat4.xz = vec2(u_xlat28) + vec2(1.0, -1.0);
					    u_xlat28 = (u_xlatb30) ? u_xlat4.z : u_xlat28;
					    u_xlat28 = (u_xlatb29) ? u_xlat4.x : u_xlat28;
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat14.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat14.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat28 = _scalar_intNormal;
					    u_xlat28 = clamp(u_xlat28, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat28 * u_xlat0.x + 1.0;
					    u_xlat10_23.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat28 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat28 = u_xlat10_23.x * u_xlat28 + _scalar_minrg;
					    u_xlat28 = (-u_xlat28) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat9.xyz = u_xlat9.xyz * u_xlat5.yyy;
					    u_xlat9.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat9.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat9.xyz;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat27 = inversesqrt(u_xlat27);
					    u_xlat0.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    u_xlatb1.xy = equal(unity_ProbeVolumeParams.xxxx, vec4(0.0, 1.0, 0.0, 0.0)).xy;
					    if(u_xlatb1.x){
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(unity_SHAr, u_xlat0);
					        u_xlat2.y = dot(unity_SHAg, u_xlat0);
					        u_xlat2.z = dot(unity_SHAb, u_xlat0);
					        u_xlat6 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat6);
					        u_xlat5.y = dot(unity_SHBg, u_xlat6);
					        u_xlat5.z = dot(unity_SHBb, u_xlat6);
					        u_xlat1.x = u_xlat0.y * u_xlat0.y;
					        u_xlat1.x = u_xlat0.x * u_xlat0.x + (-u_xlat1.x);
					        u_xlat5.xyz = unity_SHC.xyz * u_xlat1.xxx + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					    } else {
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb1.x = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat6.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + u_xlat6.xyz;
					        u_xlat5.xyz = (u_xlatb1.x) ? u_xlat5.xyz : vs_TEXCOORD0.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat1.x = u_xlat6.y * 0.25;
					        u_xlat19 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat29 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat1.x = max(u_xlat19, u_xlat1.x);
					        u_xlat6.x = min(u_xlat29, u_xlat1.x);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat6.xzw, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_8 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(u_xlat10_7, u_xlat0);
					        u_xlat2.y = dot(u_xlat10_8, u_xlat0);
					        u_xlat2.z = dot(u_xlat10_6, u_xlat0);
					    //ENDIF
					    }
					    if(u_xlatb1.y){
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat1.xyz;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat1.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb27 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat5.xyz;
					        u_xlat1.xyz = (bool(u_xlatb27)) ? u_xlat1.xyz : vs_TEXCOORD0.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat1.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat27 = u_xlat6.y * 0.25 + 0.75;
					        u_xlat1.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
					        u_xlat6.x = max(u_xlat27, u_xlat1.x);
					        SV_Target4 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					    } else {
					        SV_Target4 = unity_ProbesOcclusion;
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat2.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat28) + 1.0;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat27 = max(u_xlat27, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat27);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_27 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_27 = u_xlat10_27 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_27);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat27 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb28 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb28) ? u_xlat27 : (-u_xlat27);
					    u_xlat27 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat27 = float(1.0) / float(u_xlat27);
					    u_xlat2.xzw = vec3(u_xlat27) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb20.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb20.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb20.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat27) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu18.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu18.y * 16u + u_xlatu18.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_23.yyy * u_xlat1.xyz;
					    u_xlat27 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat27 = u_xlat27 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "SHADOWS_SHADOWMASK" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unity_ProbesOcclusion;
						vec4 unused_0_15[9];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					layout(location = 4) out vec4 SV_Target4;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bvec2 u_xlatb1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec4 u_xlat10_8;
					vec3 u_xlat9;
					bool u_xlatb9;
					vec3 u_xlat14;
					uvec2 u_xlatu18;
					float u_xlat19;
					bvec2 u_xlatb20;
					vec2 u_xlat10_23;
					float u_xlat27;
					float u_xlat16_27;
					float u_xlat10_27;
					bool u_xlatb27;
					float u_xlat28;
					bool u_xlatb28;
					float u_xlat29;
					bool u_xlatb29;
					float u_xlat30;
					bool u_xlatb30;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb9 = 0.0<vs_TEXCOORD2.w;
					    u_xlat9.x = (u_xlatb9) ? 1.0 : -1.0;
					    u_xlat9.x = u_xlat9.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat9.xyz = u_xlat9.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat9.xyz = u_xlat0.xxx * u_xlat9.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlatb29 = 1.0<abs(u_xlat28);
					    u_xlat30 = abs(u_xlat28) + -1.0;
					    u_xlat28 = (u_xlatb29) ? u_xlat30 : abs(u_xlat28);
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat28 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat29 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat28 = u_xlat28 / u_xlat29;
					    u_xlat28 = u_xlat28 + u_xlat5.z;
					    u_xlat29 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat29;
					    u_xlat28 = abs(u_xlat28) + _scalar_hueshift;
					    u_xlatb29 = u_xlat28<0.0;
					    u_xlatb30 = 1.0<u_xlat28;
					    u_xlat4.xz = vec2(u_xlat28) + vec2(1.0, -1.0);
					    u_xlat28 = (u_xlatb30) ? u_xlat4.z : u_xlat28;
					    u_xlat28 = (u_xlatb29) ? u_xlat4.x : u_xlat28;
					    u_xlat4.xzw = vec3(u_xlat28) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat14.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat14.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat28 = _scalar_intNormal;
					    u_xlat28 = clamp(u_xlat28, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat28 * u_xlat0.x + 1.0;
					    u_xlat10_23.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat28 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat28 = u_xlat10_23.x * u_xlat28 + _scalar_minrg;
					    u_xlat28 = (-u_xlat28) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat9.xyz = u_xlat9.xyz * u_xlat5.yyy;
					    u_xlat9.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat9.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat9.xyz;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat27 = inversesqrt(u_xlat27);
					    u_xlat0.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    u_xlatb1.xy = equal(unity_ProbeVolumeParams.xxxx, vec4(0.0, 1.0, 0.0, 0.0)).xy;
					    if(u_xlatb1.x){
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(unity_SHAr, u_xlat0);
					        u_xlat2.y = dot(unity_SHAg, u_xlat0);
					        u_xlat2.z = dot(unity_SHAb, u_xlat0);
					        u_xlat6 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat6);
					        u_xlat5.y = dot(unity_SHBg, u_xlat6);
					        u_xlat5.z = dot(unity_SHBb, u_xlat6);
					        u_xlat1.x = u_xlat0.y * u_xlat0.y;
					        u_xlat1.x = u_xlat0.x * u_xlat0.x + (-u_xlat1.x);
					        u_xlat5.xyz = unity_SHC.xyz * u_xlat1.xxx + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					    } else {
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb1.x = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat6.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + u_xlat6.xyz;
					        u_xlat5.xyz = (u_xlatb1.x) ? u_xlat5.xyz : vs_TEXCOORD0.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat1.x = u_xlat6.y * 0.25;
					        u_xlat19 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat29 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat1.x = max(u_xlat19, u_xlat1.x);
					        u_xlat6.x = min(u_xlat29, u_xlat1.x);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat6.xzw, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_8 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat5.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat2.x = dot(u_xlat10_7, u_xlat0);
					        u_xlat2.y = dot(u_xlat10_8, u_xlat0);
					        u_xlat2.z = dot(u_xlat10_6, u_xlat0);
					    //ENDIF
					    }
					    if(u_xlatb1.y){
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat1.xyz;
					        u_xlat1.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat1.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb27 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat5.xyz;
					        u_xlat1.xyz = (bool(u_xlatb27)) ? u_xlat1.xyz : vs_TEXCOORD0.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat1.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat27 = u_xlat6.y * 0.25 + 0.75;
					        u_xlat1.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
					        u_xlat6.x = max(u_xlat27, u_xlat1.x);
					        SV_Target4 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					    } else {
					        SV_Target4 = unity_ProbesOcclusion;
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat2.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat28) + 1.0;
					    u_xlat27 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat27 = max(u_xlat27, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat27);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_27 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_27 = u_xlat10_27 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_27);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat27 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb28 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb28) ? u_xlat27 : (-u_xlat27);
					    u_xlat27 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat27 = float(1.0) / float(u_xlat27);
					    u_xlat2.xzw = vec3(u_xlat27) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb20.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb20.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb20.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat27) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu18.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu18.y * 16u + u_xlatu18.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_23.yyy * u_xlat1.xyz;
					    u_xlat27 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat27 = u_xlat27 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat27) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "_ALPHATEST_ON" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unused_0_14[10];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec3 u_xlat8;
					bool u_xlatb8;
					float u_xlat10;
					float u_xlat12;
					vec3 u_xlat13;
					uvec2 u_xlatu16;
					bvec2 u_xlatb18;
					vec2 u_xlat10_21;
					float u_xlat24;
					float u_xlat16_24;
					float u_xlat10_24;
					float u_xlat25;
					bool u_xlatb25;
					float u_xlat26;
					bool u_xlatb26;
					float u_xlat27;
					bool u_xlatb27;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb8 = 0.0<vs_TEXCOORD2.w;
					    u_xlat8.x = (u_xlatb8) ? 1.0 : -1.0;
					    u_xlat8.x = u_xlat8.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat8.xyz = u_xlat8.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat8.xyz = u_xlat0.xxx * u_xlat8.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlatb26 = 1.0<abs(u_xlat25);
					    u_xlat27 = abs(u_xlat25) + -1.0;
					    u_xlat25 = (u_xlatb26) ? u_xlat27 : abs(u_xlat25);
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlat25 = abs(u_xlat25) + _scalar_hueshift;
					    u_xlatb26 = u_xlat25<0.0;
					    u_xlatb27 = 1.0<u_xlat25;
					    u_xlat4.xz = vec2(u_xlat25) + vec2(1.0, -1.0);
					    u_xlat25 = (u_xlatb27) ? u_xlat4.z : u_xlat25;
					    u_xlat25 = (u_xlatb26) ? u_xlat4.x : u_xlat25;
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat13.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat13.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat25 = _scalar_intNormal;
					    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat25 * u_xlat0.x + 1.0;
					    u_xlat10_21.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat25 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat25 = u_xlat10_21.x * u_xlat25 + _scalar_minrg;
					    u_xlat25 = (-u_xlat25) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat5.yyy;
					    u_xlat8.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat8.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat8.xyz;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat24 = inversesqrt(u_xlat24);
					    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    u_xlatb1 = unity_ProbeVolumeParams.x==0.0;
					    if(u_xlatb1){
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(unity_SHAr, u_xlat0);
					        u_xlat1.y = dot(unity_SHAg, u_xlat0);
					        u_xlat1.z = dot(unity_SHAb, u_xlat0);
					        u_xlat2 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat2);
					        u_xlat5.y = dot(unity_SHBg, u_xlat2);
					        u_xlat5.z = dot(unity_SHBb, u_xlat2);
					        u_xlat2.x = u_xlat0.y * u_xlat0.y;
					        u_xlat2.x = u_xlat0.x * u_xlat0.x + (-u_xlat2.x);
					        u_xlat2.xyz = unity_SHC.xyz * u_xlat2.xxx + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat2.xyz;
					    } else {
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb26 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					        u_xlat2.xyz = (bool(u_xlatb26)) ? u_xlat2.xyz : vs_TEXCOORD0.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat2.yzw = u_xlat2.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat10 = u_xlat2.y * 0.25;
					        u_xlat27 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat12 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat10 = max(u_xlat10, u_xlat27);
					        u_xlat2.x = min(u_xlat12, u_xlat10);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat2.xzw, 0.0);
					        u_xlat5.xyz = u_xlat2.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat2.xyz = u_xlat2.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_2 = textureLod(unity_ProbeVolumeSH, u_xlat2.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(u_xlat10_6, u_xlat0);
					        u_xlat1.y = dot(u_xlat10_7, u_xlat0);
					        u_xlat1.z = dot(u_xlat10_2, u_xlat0);
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat25) + 1.0;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat24 = max(u_xlat24, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat24);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_24 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_24 = u_xlat10_24 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_24);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat24 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb25 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb25) ? u_xlat24 : (-u_xlat24);
					    u_xlat24 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat24 = float(1.0) / float(u_xlat24);
					    u_xlat2.xzw = vec3(u_xlat24) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb18.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb18.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb18.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat24) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu16.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu16.y * 16u + u_xlatu16.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_21.yyy * u_xlat1.xyz;
					    u_xlat24 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat24 = u_xlat24 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" "_DOUBLESIDED_ON" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unused_0_14[10];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[11];
						vec4 _DoubleSidedConstants;
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat7;
					vec4 u_xlat10_7;
					vec3 u_xlat8;
					bool u_xlatb8;
					float u_xlat10;
					float u_xlat12;
					vec3 u_xlat13;
					uvec2 u_xlatu16;
					bvec2 u_xlatb18;
					vec2 u_xlat10_21;
					float u_xlat24;
					float u_xlat16_24;
					float u_xlat10_24;
					float u_xlat25;
					bool u_xlatb25;
					float u_xlat26;
					bool u_xlatb26;
					float u_xlat27;
					bool u_xlatb27;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb8 = 0.0<vs_TEXCOORD2.w;
					    u_xlat8.x = (u_xlatb8) ? 1.0 : -1.0;
					    u_xlat8.x = u_xlat8.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat8.xyz = u_xlat8.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat8.xyz = u_xlat0.xxx * u_xlat8.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : _DoubleSidedConstants.zx;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xxx;
					    u_xlat5.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat7.xy = u_xlat5.xy + (-u_xlat6.xy);
					    u_xlat7.z = float(1.0);
					    u_xlat7.w = float(-1.0);
					    u_xlat6 = u_xlat0.xxxx * u_xlat7 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat6.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat6.xyw;
					    u_xlat6.xyw = u_xlat5.wyx;
					    u_xlat6 = (-u_xlat5) + u_xlat6;
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlatb26 = 1.0<abs(u_xlat25);
					    u_xlat27 = abs(u_xlat25) + -1.0;
					    u_xlat25 = (u_xlatb26) ? u_xlat27 : abs(u_xlat25);
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat6.xyw = u_xlat4.zwx * u_xlat5.xxx;
					    u_xlatb0 = u_xlat6.x>=u_xlat6.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat7.xy = u_xlat6.yx;
					    u_xlat7.z = float(-1.0);
					    u_xlat7.w = float(0.666666687);
					    u_xlat5.xy = u_xlat5.xx * u_xlat4.zw + (-u_xlat7.xy);
					    u_xlat5.z = float(1.0);
					    u_xlat5.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat7;
					    u_xlatb0 = u_xlat6.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat6.wyx;
					    u_xlat5 = (-u_xlat6) + u_xlat5;
					    u_xlat5 = u_xlat0.xxxx * u_xlat5 + u_xlat6;
					    u_xlat0.x = min(u_xlat5.y, u_xlat5.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat5.x;
					    u_xlat25 = (-u_xlat5.y) + u_xlat5.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat5.z;
					    u_xlat26 = u_xlat5.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlat25 = abs(u_xlat25) + _scalar_hueshift;
					    u_xlatb26 = u_xlat25<0.0;
					    u_xlatb27 = 1.0<u_xlat25;
					    u_xlat4.xz = vec2(u_xlat25) + vec2(1.0, -1.0);
					    u_xlat25 = (u_xlatb27) ? u_xlat4.z : u_xlat25;
					    u_xlat25 = (u_xlatb26) ? u_xlat4.x : u_xlat25;
					    u_xlat4.xzw = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat4.xzw = fract(u_xlat4.xzw);
					    u_xlat4.xzw = u_xlat4.xzw * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat4.xzw = abs(u_xlat4.xzw) + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = clamp(u_xlat4.xzw, 0.0, 1.0);
					    u_xlat4.xzw = u_xlat4.xzw + vec3(-1.0, -1.0, -1.0);
					    u_xlat4.xzw = u_xlat0.xxx * u_xlat4.xzw + vec3(1.0, 1.0, 1.0);
					    u_xlat13.xyz = u_xlat4.xzw * u_xlat5.xxx;
					    u_xlat0.x = dot(u_xlat13.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xzw = u_xlat5.xxx * u_xlat4.xzw + (-u_xlat0.xxx);
					    u_xlat4.xzw = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xzw + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat25 = _scalar_intNormal;
					    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat25 * u_xlat0.x + 1.0;
					    u_xlat10_21.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat25 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat25 = u_xlat10_21.x * u_xlat25 + _scalar_minrg;
					    u_xlat25 = (-u_xlat25) + 1.0;
					    u_xlat5.xy = u_xlat4.yy * u_xlat5.xy;
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat5.yyy;
					    u_xlat8.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat8.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat8.xyz;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat24 = inversesqrt(u_xlat24);
					    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    u_xlatb1 = unity_ProbeVolumeParams.x==0.0;
					    if(u_xlatb1){
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(unity_SHAr, u_xlat0);
					        u_xlat1.y = dot(unity_SHAg, u_xlat0);
					        u_xlat1.z = dot(unity_SHAb, u_xlat0);
					        u_xlat2 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat2);
					        u_xlat5.y = dot(unity_SHBg, u_xlat2);
					        u_xlat5.z = dot(unity_SHBb, u_xlat2);
					        u_xlat2.x = u_xlat0.y * u_xlat0.y;
					        u_xlat2.x = u_xlat0.x * u_xlat0.x + (-u_xlat2.x);
					        u_xlat2.xyz = unity_SHC.xyz * u_xlat2.xxx + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat2.xyz;
					    } else {
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb26 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					        u_xlat2.xyz = (bool(u_xlatb26)) ? u_xlat2.xyz : vs_TEXCOORD0.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat2.yzw = u_xlat2.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat10 = u_xlat2.y * 0.25;
					        u_xlat27 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat12 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat10 = max(u_xlat10, u_xlat27);
					        u_xlat2.x = min(u_xlat12, u_xlat10);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat2.xzw, 0.0);
					        u_xlat5.xyz = u_xlat2.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat2.xyz = u_xlat2.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_2 = textureLod(unity_ProbeVolumeSH, u_xlat2.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(u_xlat10_6, u_xlat0);
					        u_xlat1.y = dot(u_xlat10_7, u_xlat0);
					        u_xlat1.z = dot(u_xlat10_2, u_xlat0);
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat25) + 1.0;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat24 = max(u_xlat24, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat24);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_24 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_24 = u_xlat10_24 + 0.5;
					    u_xlat2.xzw = u_xlat4.xzw * vec3(u_xlat16_24);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat24 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb25 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb25) ? u_xlat24 : (-u_xlat24);
					    u_xlat24 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat24 = float(1.0) / float(u_xlat24);
					    u_xlat2.xzw = vec3(u_xlat24) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb18.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb18.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb18.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat24) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu16.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu16.y * 16u + u_xlatu16.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_21.yyy * u_xlat1.xyz;
					    u_xlat24 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat24 = u_xlat24 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xzw;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DECALS_OFF" "DIRLIGHTMAP_COMBINED" }
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[9];
						vec4 unity_WorldTransformParams;
						vec4 unused_0_2[3];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unity_SHBr;
						vec4 unity_SHBg;
						vec4 unity_SHBb;
						vec4 unity_SHC;
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec4 unity_ProbeVolumeSizeInv;
						vec4 unity_ProbeVolumeMin;
						vec4 unused_0_14[10];
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						mat4x4 _ViewMatrix;
						vec4 unused_1_1[36];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_3[6];
						vec4 unity_OrthoParams;
						vec4 unused_1_5[312];
						vec4 _IndirectLightingMultiplier;
						vec4 unused_1_7[88];
						float _ProbeExposureScale;
						vec4 unused_1_9;
					};
					layout(binding = 2, std140) uniform UnityPerMaterial {
						float _scalar_hueshift;
						float _scalar_saturation;
						float _scalar_intNormal;
						float _scalar_minrg;
						float _scalar_maxrg;
						vec4 unused_2_5[12];
					};
					layout(location = 3) uniform  sampler3D unity_ProbeVolumeSH;
					layout(location = 4) uniform  sampler2D _ExposureTexture;
					layout(location = 5) uniform  sampler2D _PreIntegratedFGD_GGXDisneyDiffuse;
					layout(location = 6) uniform  sampler2D _texture2D_color;
					layout(location = 7) uniform  sampler2D _texture2D_normal;
					layout(location = 8) uniform  sampler2D _texture2D_maskPBR;
					layout(location = 0) in  vec3 vs_TEXCOORD0;
					layout(location = 1) in  vec3 vs_TEXCOORD1;
					layout(location = 2) in  vec4 vs_TEXCOORD2;
					layout(location = 3) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					layout(location = 1) out vec4 SV_Target1;
					layout(location = 2) out vec4 SV_Target2;
					layout(location = 3) out vec4 SV_Target3;
					vec4 u_xlat0;
					uvec3 u_xlatu0;
					bool u_xlatb0;
					vec3 u_xlat1;
					bool u_xlatb1;
					vec4 u_xlat2;
					vec4 u_xlat10_2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat10_6;
					vec4 u_xlat10_7;
					vec3 u_xlat8;
					bool u_xlatb8;
					float u_xlat10;
					vec3 u_xlat12;
					uvec2 u_xlatu16;
					bvec2 u_xlatb18;
					vec2 u_xlat10_21;
					float u_xlat24;
					float u_xlat16_24;
					float u_xlat10_24;
					float u_xlat25;
					bool u_xlatb25;
					float u_xlat26;
					bool u_xlatb26;
					float u_xlat27;
					bool u_xlatb27;
					float u_xlat28;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = max(u_xlat0.x, 1.17549435e-38);
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlatb8 = 0.0<vs_TEXCOORD2.w;
					    u_xlat8.x = (u_xlatb8) ? 1.0 : -1.0;
					    u_xlat8.x = u_xlat8.x * unity_WorldTransformParams.w;
					    u_xlat1.xyz = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
					    u_xlat1.xyz = vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy + (-u_xlat1.xyz);
					    u_xlat8.xyz = u_xlat8.xxx * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.xxx * vs_TEXCOORD2.xyz;
					    u_xlat8.xyz = u_xlat0.xxx * u_xlat8.xyz;
					    u_xlat2.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
					    u_xlatb0 = unity_OrthoParams.w==0.0;
					    u_xlat3.x = (u_xlatb0) ? (-vs_TEXCOORD0.x) : _ViewMatrix[0].z;
					    u_xlat3.y = (u_xlatb0) ? (-vs_TEXCOORD0.y) : _ViewMatrix[1].z;
					    u_xlat3.z = (u_xlatb0) ? (-vs_TEXCOORD0.z) : _ViewMatrix[2].z;
					    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat4.xyw = texture(_texture2D_color, vs_TEXCOORD3.xy).yzx;
					    u_xlatb0 = u_xlat4.x>=u_xlat4.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xy = u_xlat4.yx;
					    u_xlat5.z = float(-1.0);
					    u_xlat5.w = float(0.666666687);
					    u_xlat6.xy = u_xlat4.xy + (-u_xlat5.xy);
					    u_xlat6.z = float(1.0);
					    u_xlat6.w = float(-1.0);
					    u_xlat5 = u_xlat0.xxxx * u_xlat6 + u_xlat5;
					    u_xlatb0 = u_xlat4.w>=u_xlat5.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat4.xyz = u_xlat5.xyw;
					    u_xlat5.xyw = u_xlat4.wyx;
					    u_xlat5 = (-u_xlat4) + u_xlat5;
					    u_xlat4 = u_xlat0.xxxx * u_xlat5 + u_xlat4;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat25 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat4.z;
					    u_xlat26 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlatb26 = 1.0<abs(u_xlat25);
					    u_xlat27 = abs(u_xlat25) + -1.0;
					    u_xlat25 = (u_xlatb26) ? u_xlat27 : abs(u_xlat25);
					    u_xlat12.xyz = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat12.xyz = fract(u_xlat12.xyz);
					    u_xlat12.xyz = u_xlat12.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat12.xyz = abs(u_xlat12.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = clamp(u_xlat12.xyz, 0.0, 1.0);
					    u_xlat12.xyz = u_xlat12.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = u_xlat0.xxx * u_xlat12.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyw = u_xlat12.yzx * u_xlat4.xxx;
					    u_xlatb0 = u_xlat5.x>=u_xlat5.y;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat6.xy = u_xlat5.yx;
					    u_xlat6.z = float(-1.0);
					    u_xlat6.w = float(0.666666687);
					    u_xlat4.xy = u_xlat4.xx * u_xlat12.yz + (-u_xlat6.xy);
					    u_xlat4.z = float(1.0);
					    u_xlat4.w = float(-1.0);
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat6;
					    u_xlatb0 = u_xlat5.w>=u_xlat4.x;
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat5.xyz = u_xlat4.xyw;
					    u_xlat4.xyw = u_xlat5.wyx;
					    u_xlat4 = (-u_xlat5) + u_xlat4;
					    u_xlat4 = u_xlat0.xxxx * u_xlat4 + u_xlat5;
					    u_xlat0.x = min(u_xlat4.y, u_xlat4.w);
					    u_xlat0.x = (-u_xlat0.x) + u_xlat4.x;
					    u_xlat25 = (-u_xlat4.y) + u_xlat4.w;
					    u_xlat26 = u_xlat0.x * 6.0 + 9.99999975e-05;
					    u_xlat25 = u_xlat25 / u_xlat26;
					    u_xlat25 = u_xlat25 + u_xlat4.z;
					    u_xlat26 = u_xlat4.x + 9.99999975e-05;
					    u_xlat0.x = u_xlat0.x / u_xlat26;
					    u_xlat25 = abs(u_xlat25) + _scalar_hueshift;
					    u_xlatb26 = u_xlat25<0.0;
					    u_xlatb27 = 1.0<u_xlat25;
					    u_xlat12.xy = vec2(u_xlat25) + vec2(1.0, -1.0);
					    u_xlat25 = (u_xlatb27) ? u_xlat12.y : u_xlat25;
					    u_xlat25 = (u_xlatb26) ? u_xlat12.x : u_xlat25;
					    u_xlat12.xyz = vec3(u_xlat25) + vec3(1.0, 0.666666687, 0.333333343);
					    u_xlat12.xyz = fract(u_xlat12.xyz);
					    u_xlat12.xyz = u_xlat12.xyz * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -3.0, -3.0);
					    u_xlat12.xyz = abs(u_xlat12.xyz) + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = clamp(u_xlat12.xyz, 0.0, 1.0);
					    u_xlat12.xyz = u_xlat12.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat12.xyz = u_xlat0.xxx * u_xlat12.xyz + vec3(1.0, 1.0, 1.0);
					    u_xlat5.xyz = u_xlat12.xyz * u_xlat4.xxx;
					    u_xlat0.x = dot(u_xlat5.xyz, vec3(0.212672904, 0.715152204, 0.0721750036));
					    u_xlat4.xyz = u_xlat4.xxx * u_xlat12.xyz + (-u_xlat0.xxx);
					    u_xlat4.xyz = vec3(vec3(_scalar_saturation, _scalar_saturation, _scalar_saturation)) * u_xlat4.xyz + u_xlat0.xxx;
					    u_xlat5.xyz = texture(_texture2D_normal, vs_TEXCOORD3.xy).xyw;
					    u_xlat5.x = u_xlat5.x * u_xlat5.z;
					    u_xlat5.xy = u_xlat5.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat0.x = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat5.xy = u_xlat5.xy * vec2(vec2(_scalar_intNormal, _scalar_intNormal));
					    u_xlat25 = _scalar_intNormal;
					    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
					    u_xlat0.x = u_xlat0.x + -1.0;
					    u_xlat0.x = u_xlat25 * u_xlat0.x + 1.0;
					    u_xlat10_21.xy = texture(_texture2D_maskPBR, vs_TEXCOORD3.xy).xz;
					    u_xlat25 = (-_scalar_minrg) + _scalar_maxrg;
					    u_xlat25 = u_xlat10_21.x * u_xlat25 + _scalar_minrg;
					    u_xlat25 = (-u_xlat25) + 1.0;
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat5.yyy;
					    u_xlat8.xyz = u_xlat5.xxx * u_xlat1.xyz + u_xlat8.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz + u_xlat8.xyz;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat24 = inversesqrt(u_xlat24);
					    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    u_xlatb1 = unity_ProbeVolumeParams.x==0.0;
					    if(u_xlatb1){
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(unity_SHAr, u_xlat0);
					        u_xlat1.y = dot(unity_SHAg, u_xlat0);
					        u_xlat1.z = dot(unity_SHAb, u_xlat0);
					        u_xlat2 = u_xlat0.yzzx * u_xlat0.xyzz;
					        u_xlat5.x = dot(unity_SHBr, u_xlat2);
					        u_xlat5.y = dot(unity_SHBg, u_xlat2);
					        u_xlat5.z = dot(unity_SHBb, u_xlat2);
					        u_xlat2.x = u_xlat0.y * u_xlat0.y;
					        u_xlat2.x = u_xlat0.x * u_xlat0.x + (-u_xlat2.x);
					        u_xlat2.xyz = unity_SHC.xyz * u_xlat2.xxx + u_xlat5.xyz;
					        u_xlat1.xyz = u_xlat1.xyz + u_xlat2.xyz;
					    } else {
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[1].xyz * _WorldSpaceCameraPos.yyy;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
					        u_xlat2.xyz = unity_ProbeVolumeWorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlatb26 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD0.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD0.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD0.zzz + u_xlat5.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + u_xlat5.xyz;
					        u_xlat2.xyz = (bool(u_xlatb26)) ? u_xlat2.xyz : vs_TEXCOORD0.xyz;
					        u_xlat2.xyz = u_xlat2.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat2.yzw = u_xlat2.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat10 = u_xlat2.y * 0.25;
					        u_xlat27 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat28 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat10 = max(u_xlat10, u_xlat27);
					        u_xlat2.x = min(u_xlat28, u_xlat10);
					        u_xlat10_6 = textureLod(unity_ProbeVolumeSH, u_xlat2.xzw, 0.0);
					        u_xlat5.xyz = u_xlat2.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat10_7 = textureLod(unity_ProbeVolumeSH, u_xlat5.xyz, 0.0);
					        u_xlat2.xyz = u_xlat2.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat10_2 = textureLod(unity_ProbeVolumeSH, u_xlat2.xyz, 0.0);
					        u_xlat0.w = 1.0;
					        u_xlat1.x = dot(u_xlat10_6, u_xlat0);
					        u_xlat1.y = dot(u_xlat10_7, u_xlat0);
					        u_xlat1.z = dot(u_xlat10_2, u_xlat0);
					    //ENDIF
					    }
					    u_xlat1.xyz = u_xlat1.xyz * _IndirectLightingMultiplier.xxx;
					    u_xlat2.y = (-u_xlat25) + 1.0;
					    u_xlat24 = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat24 = max(u_xlat24, 9.99999975e-05);
					    u_xlat2.x = sqrt(u_xlat24);
					    u_xlat2.xz = u_xlat2.xy * vec2(0.984375, 0.984375) + vec2(0.0078125, 0.0078125);
					    u_xlat10_24 = textureLod(_PreIntegratedFGD_GGXDisneyDiffuse, u_xlat2.xz, 0.0).z;
					    u_xlat16_24 = u_xlat10_24 + 0.5;
					    u_xlat2.xzw = u_xlat4.xyz * vec3(u_xlat16_24);
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xzw;
					    u_xlat24 = max(abs(u_xlat0.z), 0.0009765625);
					    u_xlatb25 = u_xlat0.z>=0.0;
					    u_xlat0.z = (u_xlatb25) ? u_xlat24 : (-u_xlat24);
					    u_xlat24 = dot(abs(u_xlat0.xyz), vec3(1.0, 1.0, 1.0));
					    u_xlat24 = float(1.0) / float(u_xlat24);
					    u_xlat2.xzw = vec3(u_xlat24) * u_xlat0.zxy;
					    u_xlat2.x = (-u_xlat2.x);
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					    u_xlatb18.xy = greaterThanEqual(u_xlat2.zwzw, vec4(0.0, 0.0, 0.0, 0.0)).xy;
					    {
					        vec4 hlslcc_movcTemp = u_xlat2;
					        hlslcc_movcTemp.x = (u_xlatb18.x) ? u_xlat2.x : (-u_xlat2.x);
					        hlslcc_movcTemp.z = (u_xlatb18.y) ? u_xlat2.x : (-u_xlat2.x);
					        u_xlat2 = hlslcc_movcTemp;
					    }
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat24) + u_xlat2.xz;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + vec2(0.5, 0.5);
					    u_xlat0.xy = clamp(u_xlat0.xy, 0.0, 1.0);
					    u_xlat0.xy = u_xlat0.xy * vec2(4095.5, 4095.5);
					    u_xlatu0.xy = uvec2(u_xlat0.xy);
					    u_xlatu16.xy = u_xlatu0.xy >> uvec2(8u, 8u);
					    u_xlatu0.xy = u_xlatu0.xy & uvec2(255u, 255u);
					    u_xlatu0.z = u_xlatu16.y * 16u + u_xlatu16.x;
					    u_xlat3.xyz = vec3(u_xlatu0.xyz);
					    SV_Target1.xyz = u_xlat3.xyz * vec3(0.00392156886, 0.00392156886, 0.00392156886);
					    u_xlat0.xyz = u_xlat10_21.yyy * u_xlat1.xyz;
					    u_xlat24 = texelFetch(_ExposureTexture, ivec2(0, 0), int(0)).x;
					    u_xlat24 = u_xlat24 * _ProbeExposureScale;
					    SV_Target3.xyz = vec3(u_xlat24) * u_xlat0.xyz;
					    SV_Target3.w = 0.0;
					    SV_Target0.xyz = u_xlat4.xyz;
					    SV_Target0.w = 1.0;
					    SV_Target1.w = u_xlat2.y;
					    SV_Target2 = vec4(0.220916361, 0.220916361, 0.220916361, 0.0);
					    return;
					}"
				}
			}
		}
		Pass {
			Name "MotionVectors"
			Tags { "LIGHTMODE" = "MOTIONVECTORS" "QUEUE" = "AlphaTest+0" "RenderPipeline" = "HDRenderPipeline" "RenderType" = "HDLitShader" }
			Cull Off
			Stencil {
				WriteMask 0
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 386840
			Program "vp" {
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[20];
						mat4x4 unity_MatrixPreviousM;
						vec4 unused_0_4[4];
						vec4 unity_MotionVectorsParams;
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[8];
						mat4x4 _NonJitteredViewProjMatrix;
						mat4x4 _PrevViewProjMatrix;
						vec4 unused_1_5[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_7[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 6) in  vec4 in_TEXCOORD3;
					layout(location = 7) in  vec4 in_COLOR0;
					layout(location = 8) in  vec3 in_TEXCOORD4;
					layout(location = 0) out vec3 vs_TEXCOORD8;
					layout(location = 1) out vec3 vs_TEXCOORD9;
					layout(location = 2) out vec3 vs_TEXCOORD0;
					layout(location = 3) out vec3 vs_TEXCOORD1;
					layout(location = 4) out vec4 vs_TEXCOORD2;
					layout(location = 5) out vec4 vs_TEXCOORD3;
					layout(location = 6) out vec4 vs_TEXCOORD4;
					layout(location = 7) out vec4 vs_TEXCOORD5;
					layout(location = 8) out vec4 vs_TEXCOORD6;
					layout(location = 9) out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					bool u_xlatb0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat1.x = unity_ObjectToWorld[0].x;
					    u_xlat1.y = unity_ObjectToWorld[1].x;
					    u_xlat1.z = unity_ObjectToWorld[2].x;
					    u_xlat1.w = u_xlat0.x;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat1.x = dot(u_xlat1, u_xlat2);
					    u_xlat3.x = unity_ObjectToWorld[0].y;
					    u_xlat3.y = unity_ObjectToWorld[1].y;
					    u_xlat3.z = unity_ObjectToWorld[2].y;
					    u_xlat3.w = u_xlat0.y;
					    u_xlat1.y = dot(u_xlat3, u_xlat2);
					    u_xlat0.x = unity_ObjectToWorld[0].z;
					    u_xlat0.y = unity_ObjectToWorld[1].z;
					    u_xlat0.z = unity_ObjectToWorld[2].z;
					    u_xlat1.z = dot(u_xlat0, u_xlat2);
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = max(u_xlat12, 1.17549435e-38);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD1.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = max(u_xlat12, 1.17549435e-38);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD2.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * _ViewProjMatrix[1];
					    u_xlat0 = _ViewProjMatrix[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = _ViewProjMatrix[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = u_xlat0 + _ViewProjMatrix[3];
					    u_xlat0.xyz = u_xlat1.yyy * _NonJitteredViewProjMatrix[1].xyw;
					    u_xlat0.xyz = _NonJitteredViewProjMatrix[0].xyw * u_xlat1.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = _NonJitteredViewProjMatrix[2].xyw * u_xlat1.zzz + u_xlat0.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + _NonJitteredViewProjMatrix[3].xyw;
					    u_xlatb0 = unity_MotionVectorsParams.y==0.0;
					    if(u_xlatb0){
					        vs_TEXCOORD9.xyz = vec3(0.0, 0.0, 1.0);
					    } else {
					        u_xlatb0 = 0.0<unity_MotionVectorsParams.x;
					        u_xlat0.xyz = (bool(u_xlatb0)) ? in_TEXCOORD4.xyz : in_POSITION0.xyz;
					        u_xlat2.xyw = unity_MatrixPreviousM[3].xyz + (-_WorldSpaceCameraPos.xyz);
					        u_xlat3.x = unity_MatrixPreviousM[0].x;
					        u_xlat3.y = unity_MatrixPreviousM[1].x;
					        u_xlat3.z = unity_MatrixPreviousM[2].x;
					        u_xlat3.w = u_xlat2.x;
					        u_xlat0.w = 1.0;
					        u_xlat13 = dot(u_xlat3, u_xlat0);
					        u_xlat3.x = unity_MatrixPreviousM[0].y;
					        u_xlat3.y = unity_MatrixPreviousM[1].y;
					        u_xlat3.z = unity_MatrixPreviousM[2].y;
					        u_xlat3.w = u_xlat2.y;
					        u_xlat3.x = dot(u_xlat3, u_xlat0);
					        u_xlat2.x = unity_MatrixPreviousM[0].z;
					        u_xlat2.y = unity_MatrixPreviousM[1].z;
					        u_xlat2.z = unity_MatrixPreviousM[2].z;
					        u_xlat0.x = dot(u_xlat2, u_xlat0);
					        u_xlat4.xyz = u_xlat3.xxx * _PrevViewProjMatrix[1].xyw;
					        u_xlat4.xyz = _PrevViewProjMatrix[0].xyw * vec3(u_xlat13) + u_xlat4.xyz;
					        u_xlat0.xyz = _PrevViewProjMatrix[2].xyw * u_xlat0.xxx + u_xlat4.xyz;
					        vs_TEXCOORD9.xyz = u_xlat0.xyz + _PrevViewProjMatrix[3].xyw;
					    //ENDIF
					    }
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    vs_TEXCOORD6 = in_TEXCOORD3;
					    vs_TEXCOORD7 = in_COLOR0;
					    vs_TEXCOORD0.xyz = u_xlat1.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[20];
						mat4x4 unity_MatrixPreviousM;
						vec4 unused_0_4[4];
						vec4 unity_MotionVectorsParams;
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[8];
						mat4x4 _NonJitteredViewProjMatrix;
						mat4x4 _PrevViewProjMatrix;
						vec4 unused_1_5[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_7[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 6) in  vec4 in_TEXCOORD3;
					layout(location = 7) in  vec4 in_COLOR0;
					layout(location = 8) in  vec3 in_TEXCOORD4;
					layout(location = 0) out vec3 vs_TEXCOORD8;
					layout(location = 1) out vec3 vs_TEXCOORD9;
					layout(location = 2) out vec3 vs_TEXCOORD0;
					layout(location = 3) out vec3 vs_TEXCOORD1;
					layout(location = 4) out vec4 vs_TEXCOORD2;
					layout(location = 5) out vec4 vs_TEXCOORD3;
					layout(location = 6) out vec4 vs_TEXCOORD4;
					layout(location = 7) out vec4 vs_TEXCOORD5;
					layout(location = 8) out vec4 vs_TEXCOORD6;
					layout(location = 9) out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					bool u_xlatb0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat1.x = unity_ObjectToWorld[0].x;
					    u_xlat1.y = unity_ObjectToWorld[1].x;
					    u_xlat1.z = unity_ObjectToWorld[2].x;
					    u_xlat1.w = u_xlat0.x;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat1.x = dot(u_xlat1, u_xlat2);
					    u_xlat3.x = unity_ObjectToWorld[0].y;
					    u_xlat3.y = unity_ObjectToWorld[1].y;
					    u_xlat3.z = unity_ObjectToWorld[2].y;
					    u_xlat3.w = u_xlat0.y;
					    u_xlat1.y = dot(u_xlat3, u_xlat2);
					    u_xlat0.x = unity_ObjectToWorld[0].z;
					    u_xlat0.y = unity_ObjectToWorld[1].z;
					    u_xlat0.z = unity_ObjectToWorld[2].z;
					    u_xlat1.z = dot(u_xlat0, u_xlat2);
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = max(u_xlat12, 1.17549435e-38);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD1.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = max(u_xlat12, 1.17549435e-38);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD2.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * _ViewProjMatrix[1];
					    u_xlat0 = _ViewProjMatrix[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = _ViewProjMatrix[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = u_xlat0 + _ViewProjMatrix[3];
					    u_xlat0.xyz = u_xlat1.yyy * _NonJitteredViewProjMatrix[1].xyw;
					    u_xlat0.xyz = _NonJitteredViewProjMatrix[0].xyw * u_xlat1.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = _NonJitteredViewProjMatrix[2].xyw * u_xlat1.zzz + u_xlat0.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + _NonJitteredViewProjMatrix[3].xyw;
					    u_xlatb0 = unity_MotionVectorsParams.y==0.0;
					    if(u_xlatb0){
					        vs_TEXCOORD9.xyz = vec3(0.0, 0.0, 1.0);
					    } else {
					        u_xlatb0 = 0.0<unity_MotionVectorsParams.x;
					        u_xlat0.xyz = (bool(u_xlatb0)) ? in_TEXCOORD4.xyz : in_POSITION0.xyz;
					        u_xlat2.xyw = unity_MatrixPreviousM[3].xyz + (-_WorldSpaceCameraPos.xyz);
					        u_xlat3.x = unity_MatrixPreviousM[0].x;
					        u_xlat3.y = unity_MatrixPreviousM[1].x;
					        u_xlat3.z = unity_MatrixPreviousM[2].x;
					        u_xlat3.w = u_xlat2.x;
					        u_xlat0.w = 1.0;
					        u_xlat13 = dot(u_xlat3, u_xlat0);
					        u_xlat3.x = unity_MatrixPreviousM[0].y;
					        u_xlat3.y = unity_MatrixPreviousM[1].y;
					        u_xlat3.z = unity_MatrixPreviousM[2].y;
					        u_xlat3.w = u_xlat2.y;
					        u_xlat3.x = dot(u_xlat3, u_xlat0);
					        u_xlat2.x = unity_MatrixPreviousM[0].z;
					        u_xlat2.y = unity_MatrixPreviousM[1].z;
					        u_xlat2.z = unity_MatrixPreviousM[2].z;
					        u_xlat0.x = dot(u_xlat2, u_xlat0);
					        u_xlat4.xyz = u_xlat3.xxx * _PrevViewProjMatrix[1].xyw;
					        u_xlat4.xyz = _PrevViewProjMatrix[0].xyw * vec3(u_xlat13) + u_xlat4.xyz;
					        u_xlat0.xyz = _PrevViewProjMatrix[2].xyw * u_xlat0.xxx + u_xlat4.xyz;
					        vs_TEXCOORD9.xyz = u_xlat0.xyz + _PrevViewProjMatrix[3].xyw;
					    //ENDIF
					    }
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    vs_TEXCOORD6 = in_TEXCOORD3;
					    vs_TEXCOORD7 = in_COLOR0;
					    vs_TEXCOORD0.xyz = u_xlat1.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"vs_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_0_2[20];
						mat4x4 unity_MatrixPreviousM;
						vec4 unused_0_4[4];
						vec4 unity_MotionVectorsParams;
					};
					layout(binding = 1, std140) uniform UnityGlobal {
						vec4 unused_1_0[16];
						mat4x4 _ViewProjMatrix;
						vec4 unused_1_2[8];
						mat4x4 _NonJitteredViewProjMatrix;
						mat4x4 _PrevViewProjMatrix;
						vec4 unused_1_5[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_7[410];
					};
					layout(location = 0) in  vec3 in_POSITION0;
					layout(location = 1) in  vec3 in_NORMAL0;
					layout(location = 2) in  vec4 in_TANGENT0;
					layout(location = 3) in  vec4 in_TEXCOORD0;
					layout(location = 4) in  vec4 in_TEXCOORD1;
					layout(location = 5) in  vec4 in_TEXCOORD2;
					layout(location = 6) in  vec4 in_TEXCOORD3;
					layout(location = 7) in  vec4 in_COLOR0;
					layout(location = 8) in  vec3 in_TEXCOORD4;
					layout(location = 0) out vec3 vs_TEXCOORD8;
					layout(location = 1) out vec3 vs_TEXCOORD9;
					layout(location = 2) out vec3 vs_TEXCOORD0;
					layout(location = 3) out vec3 vs_TEXCOORD1;
					layout(location = 4) out vec4 vs_TEXCOORD2;
					layout(location = 5) out vec4 vs_TEXCOORD3;
					layout(location = 6) out vec4 vs_TEXCOORD4;
					layout(location = 7) out vec4 vs_TEXCOORD5;
					layout(location = 8) out vec4 vs_TEXCOORD6;
					layout(location = 9) out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					bool u_xlatb0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xyw = unity_ObjectToWorld[3].xyz + (-_WorldSpaceCameraPos.xyz);
					    u_xlat1.x = unity_ObjectToWorld[0].x;
					    u_xlat1.y = unity_ObjectToWorld[1].x;
					    u_xlat1.z = unity_ObjectToWorld[2].x;
					    u_xlat1.w = u_xlat0.x;
					    u_xlat2.xyz = in_POSITION0.xyz;
					    u_xlat2.w = 1.0;
					    u_xlat1.x = dot(u_xlat1, u_xlat2);
					    u_xlat3.x = unity_ObjectToWorld[0].y;
					    u_xlat3.y = unity_ObjectToWorld[1].y;
					    u_xlat3.z = unity_ObjectToWorld[2].y;
					    u_xlat3.w = u_xlat0.y;
					    u_xlat1.y = dot(u_xlat3, u_xlat2);
					    u_xlat0.x = unity_ObjectToWorld[0].z;
					    u_xlat0.y = unity_ObjectToWorld[1].z;
					    u_xlat0.z = unity_ObjectToWorld[2].z;
					    u_xlat1.z = dot(u_xlat0, u_xlat2);
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = max(u_xlat12, 1.17549435e-38);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD1.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat0.xyz;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = max(u_xlat12, 1.17549435e-38);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD2.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * _ViewProjMatrix[1];
					    u_xlat0 = _ViewProjMatrix[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = _ViewProjMatrix[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = u_xlat0 + _ViewProjMatrix[3];
					    u_xlat0.xyz = u_xlat1.yyy * _NonJitteredViewProjMatrix[1].xyw;
					    u_xlat0.xyz = _NonJitteredViewProjMatrix[0].xyw * u_xlat1.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = _NonJitteredViewProjMatrix[2].xyw * u_xlat1.zzz + u_xlat0.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + _NonJitteredViewProjMatrix[3].xyw;
					    u_xlatb0 = unity_MotionVectorsParams.y==0.0;
					    if(u_xlatb0){
					        vs_TEXCOORD9.xyz = vec3(0.0, 0.0, 1.0);
					    } else {
					        u_xlatb0 = 0.0<unity_MotionVectorsParams.x;
					        u_xlat0.xyz = (bool(u_xlatb0)) ? in_TEXCOORD4.xyz : in_POSITION0.xyz;
					        u_xlat2.xyw = unity_MatrixPreviousM[3].xyz + (-_WorldSpaceCameraPos.xyz);
					        u_xlat3.x = unity_MatrixPreviousM[0].x;
					        u_xlat3.y = unity_MatrixPreviousM[1].x;
					        u_xlat3.z = unity_MatrixPreviousM[2].x;
					        u_xlat3.w = u_xlat2.x;
					        u_xlat0.w = 1.0;
					        u_xlat13 = dot(u_xlat3, u_xlat0);
					        u_xlat3.x = unity_MatrixPreviousM[0].y;
					        u_xlat3.y = unity_MatrixPreviousM[1].y;
					        u_xlat3.z = unity_MatrixPreviousM[2].y;
					        u_xlat3.w = u_xlat2.y;
					        u_xlat3.x = dot(u_xlat3, u_xlat0);
					        u_xlat2.x = unity_MatrixPreviousM[0].z;
					        u_xlat2.y = unity_MatrixPreviousM[1].z;
					        u_xlat2.z = unity_MatrixPreviousM[2].z;
					        u_xlat0.x = dot(u_xlat2, u_xlat0);
					        u_xlat4.xyz = u_xlat3.xxx * _PrevViewProjMatrix[1].xyw;
					        u_xlat4.xyz = _PrevViewProjMatrix[0].xyw * vec3(u_xlat13) + u_xlat4.xyz;
					        u_xlat0.xyz = _PrevViewProjMatrix[2].xyw * u_xlat0.xxx + u_xlat4.xyz;
					        vs_TEXCOORD9.xyz = u_xlat0.xyz + _PrevViewProjMatrix[3].xyw;
					    //ENDIF
					    }
					    vs_TEXCOORD2.w = in_TANGENT0.w;
					    vs_TEXCOORD3 = in_TEXCOORD0;
					    vs_TEXCOORD4 = in_TEXCOORD1;
					    vs_TEXCOORD5 = in_TEXCOORD2;
					    vs_TEXCOORD6 = in_TEXCOORD3;
					    vs_TEXCOORD7 = in_COLOR0;
					    vs_TEXCOORD0.xyz = u_xlat1.xyz;
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[36];
						vec4 unity_MotionVectorsParams;
					};
					layout(location = 0) in  vec3 vs_TEXCOORD8;
					layout(location = 1) in  vec3 vs_TEXCOORD9;
					layout(location = 0) out vec4 SV_Target0;
					vec2 u_xlat0;
					vec2 u_xlat2;
					bool u_xlatb2;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.zz;
					    u_xlat2.xy = vs_TEXCOORD9.xy / vs_TEXCOORD9.zz;
					    u_xlat0.xy = (-u_xlat2.xy) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, -0.5);
					    u_xlatb2 = unity_MotionVectorsParams.y==0.0;
					    SV_Target0.xy = (bool(u_xlatb2)) ? vec2(2.0, 0.0) : u_xlat0.xy;
					    SV_Target0.zw = vec2(0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[36];
						vec4 unity_MotionVectorsParams;
					};
					layout(location = 0) in  vec3 vs_TEXCOORD8;
					layout(location = 1) in  vec3 vs_TEXCOORD9;
					layout(location = 0) out vec4 SV_Target0;
					vec2 u_xlat0;
					vec2 u_xlat2;
					bool u_xlatb2;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.zz;
					    u_xlat2.xy = vs_TEXCOORD9.xy / vs_TEXCOORD9.zz;
					    u_xlat0.xy = (-u_xlat2.xy) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, -0.5);
					    u_xlatb2 = unity_MotionVectorsParams.y==0.0;
					    SV_Target0.xy = (bool(u_xlatb2)) ? vec2(2.0, 0.0) : u_xlat0.xy;
					    SV_Target0.zw = vec2(0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					"ps_5_0
					
					#version 430
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(binding = 0, std140) uniform UnityPerDraw {
						vec4 unused_0_0[36];
						vec4 unity_MotionVectorsParams;
					};
					layout(binding = 1, std140) uniform UnityPerMaterial {
						vec4 unused_1_0[2];
						float Vector1_60D43DF8;
						vec4 unused_1_2[11];
					};
					layout(location = 2) uniform  sampler2D _texture2D_alphacut;
					layout(location = 0) in  vec3 vs_TEXCOORD8;
					layout(location = 1) in  vec3 vs_TEXCOORD9;
					layout(location = 2) in  vec4 vs_TEXCOORD3;
					layout(location = 0) out vec4 SV_Target0;
					vec2 u_xlat0;
					float u_xlat10_0;
					bool u_xlatb0;
					vec2 u_xlat2;
					bool u_xlatb2;
					void main()
					{
					    u_xlat10_0 = texture(_texture2D_alphacut, vs_TEXCOORD3.xy).x;
					    u_xlat0.x = u_xlat10_0 + (-Vector1_60D43DF8);
					    u_xlatb0 = u_xlat0.x<0.0;
					    if(((int(u_xlatb0) * int(0xffffffffu)))!=0){discard;}
					    u_xlat0.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.zz;
					    u_xlat2.xy = vs_TEXCOORD9.xy / vs_TEXCOORD9.zz;
					    u_xlat0.xy = (-u_xlat2.xy) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(0.5, -0.5);
					    u_xlatb2 = unity_MotionVectorsParams.y==0.0;
					    SV_Target0.xy = (bool(u_xlatb2)) ? vec2(2.0, 0.0) : u_xlat0.xy;
					    SV_Target0.zw = vec2(0.0, 0.0);
					    return;
					}"
				}
			}
		}
	}
	SubShader {
		Tags { "RenderPipeline" = "HDRenderPipeline" }
	}
	Fallback "Hidden/Shader Graph/FallbackError"
	CustomEditor "UnityEditor.Rendering.HighDefinition.HDLitGUI"
}