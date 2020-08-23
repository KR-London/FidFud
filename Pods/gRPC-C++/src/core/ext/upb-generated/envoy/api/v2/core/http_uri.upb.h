/* This file was generated by upbc (the upb compiler) from the input
 * file:
 *
 *     envoy/api/v2/core/http_uri.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#ifndef ENVOY_API_V2_CORE_HTTP_URI_PROTO_UPB_H_
#define ENVOY_API_V2_CORE_HTTP_URI_PROTO_UPB_H_

#if COCOAPODS==1
  #include  "third_party/upb/upb/generated_util.h"
#else
  #include  "upb/generated_util.h"
#endif
#if COCOAPODS==1
  #include  "third_party/upb/upb/msg.h"
#else
  #include  "upb/msg.h"
#endif
#if COCOAPODS==1
  #include  "third_party/upb/upb/decode.h"
#else
  #include  "upb/decode.h"
#endif
#if COCOAPODS==1
  #include  "third_party/upb/upb/encode.h"
#else
  #include  "upb/encode.h"
#endif

#if COCOAPODS==1
  #include  "third_party/upb/upb/port_def.inc"
#else
  #include  "upb/port_def.inc"
#endif

#ifdef __cplusplus
extern "C" {
#endif

struct envoy_api_v2_core_HttpUri;
typedef struct envoy_api_v2_core_HttpUri envoy_api_v2_core_HttpUri;
extern const upb_msglayout envoy_api_v2_core_HttpUri_msginit;
struct google_protobuf_Duration;
extern const upb_msglayout google_protobuf_Duration_msginit;


/* envoy.api.v2.core.HttpUri */

UPB_INLINE envoy_api_v2_core_HttpUri *envoy_api_v2_core_HttpUri_new(upb_arena *arena) {
  return (envoy_api_v2_core_HttpUri *)upb_msg_new(&envoy_api_v2_core_HttpUri_msginit, arena);
}
UPB_INLINE envoy_api_v2_core_HttpUri *envoy_api_v2_core_HttpUri_parse(const char *buf, size_t size,
                        upb_arena *arena) {
  envoy_api_v2_core_HttpUri *ret = envoy_api_v2_core_HttpUri_new(arena);
  return (ret && upb_decode(buf, size, ret, &envoy_api_v2_core_HttpUri_msginit, arena)) ? ret : NULL;
}
UPB_INLINE char *envoy_api_v2_core_HttpUri_serialize(const envoy_api_v2_core_HttpUri *msg, upb_arena *arena, size_t *len) {
  return upb_encode(msg, &envoy_api_v2_core_HttpUri_msginit, arena, len);
}

typedef enum {
  envoy_api_v2_core_HttpUri_http_upstream_type_cluster = 2,
  envoy_api_v2_core_HttpUri_http_upstream_type_NOT_SET = 0
} envoy_api_v2_core_HttpUri_http_upstream_type_oneofcases;
UPB_INLINE envoy_api_v2_core_HttpUri_http_upstream_type_oneofcases envoy_api_v2_core_HttpUri_http_upstream_type_case(const envoy_api_v2_core_HttpUri* msg) { return (envoy_api_v2_core_HttpUri_http_upstream_type_oneofcases)UPB_FIELD_AT(msg, int32_t, UPB_SIZE(20, 40)); }

UPB_INLINE upb_strview envoy_api_v2_core_HttpUri_uri(const envoy_api_v2_core_HttpUri *msg) { return UPB_FIELD_AT(msg, upb_strview, UPB_SIZE(0, 0)); }
UPB_INLINE bool envoy_api_v2_core_HttpUri_has_cluster(const envoy_api_v2_core_HttpUri *msg) { return _upb_has_oneof_field(msg, UPB_SIZE(20, 40), 2); }
UPB_INLINE upb_strview envoy_api_v2_core_HttpUri_cluster(const envoy_api_v2_core_HttpUri *msg) { return UPB_READ_ONEOF(msg, upb_strview, UPB_SIZE(12, 24), UPB_SIZE(20, 40), 2, upb_strview_make("", strlen(""))); }
UPB_INLINE const struct google_protobuf_Duration* envoy_api_v2_core_HttpUri_timeout(const envoy_api_v2_core_HttpUri *msg) { return UPB_FIELD_AT(msg, const struct google_protobuf_Duration*, UPB_SIZE(8, 16)); }

UPB_INLINE void envoy_api_v2_core_HttpUri_set_uri(envoy_api_v2_core_HttpUri *msg, upb_strview value) {
  UPB_FIELD_AT(msg, upb_strview, UPB_SIZE(0, 0)) = value;
}
UPB_INLINE void envoy_api_v2_core_HttpUri_set_cluster(envoy_api_v2_core_HttpUri *msg, upb_strview value) {
  UPB_WRITE_ONEOF(msg, upb_strview, UPB_SIZE(12, 24), value, UPB_SIZE(20, 40), 2);
}
UPB_INLINE void envoy_api_v2_core_HttpUri_set_timeout(envoy_api_v2_core_HttpUri *msg, struct google_protobuf_Duration* value) {
  UPB_FIELD_AT(msg, struct google_protobuf_Duration*, UPB_SIZE(8, 16)) = value;
}
UPB_INLINE struct google_protobuf_Duration* envoy_api_v2_core_HttpUri_mutable_timeout(envoy_api_v2_core_HttpUri *msg, upb_arena *arena) {
  struct google_protobuf_Duration* sub = (struct google_protobuf_Duration*)envoy_api_v2_core_HttpUri_timeout(msg);
  if (sub == NULL) {
    sub = (struct google_protobuf_Duration*)upb_msg_new(&google_protobuf_Duration_msginit, arena);
    if (!sub) return NULL;
    envoy_api_v2_core_HttpUri_set_timeout(msg, sub);
  }
  return sub;
}

#ifdef __cplusplus
}  /* extern "C" */
#endif

#if COCOAPODS==1
  #include  "third_party/upb/upb/port_undef.inc"
#else
  #include  "upb/port_undef.inc"
#endif

#endif  /* ENVOY_API_V2_CORE_HTTP_URI_PROTO_UPB_H_ */
