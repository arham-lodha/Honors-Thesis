// Lean compiler output
// Module: GraphonFormalization
// Imports: public import Init public meta import Init public import GraphonFormalization.Graph public import GraphonFormalization.Graphon public import GraphonFormalization.HomDensity public import GraphonFormalization.Alpha public import GraphonFormalization.UpperBound public import GraphonFormalization.LowerBound public import GraphonFormalization.MainTheorem
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_GraphonFormalization_GraphonFormalization_Graph(uint8_t builtin);
lean_object* initialize_GraphonFormalization_GraphonFormalization_Graphon(uint8_t builtin);
lean_object* initialize_GraphonFormalization_GraphonFormalization_HomDensity(uint8_t builtin);
lean_object* initialize_GraphonFormalization_GraphonFormalization_Alpha(uint8_t builtin);
lean_object* initialize_GraphonFormalization_GraphonFormalization_UpperBound(uint8_t builtin);
lean_object* initialize_GraphonFormalization_GraphonFormalization_LowerBound(uint8_t builtin);
lean_object* initialize_GraphonFormalization_GraphonFormalization_MainTheorem(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_GraphonFormalization_GraphonFormalization(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_GraphonFormalization_GraphonFormalization_Graph(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_GraphonFormalization_GraphonFormalization_Graphon(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_GraphonFormalization_GraphonFormalization_HomDensity(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_GraphonFormalization_GraphonFormalization_Alpha(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_GraphonFormalization_GraphonFormalization_UpperBound(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_GraphonFormalization_GraphonFormalization_LowerBound(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_GraphonFormalization_GraphonFormalization_MainTheorem(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
