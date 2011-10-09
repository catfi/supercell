/**
 * Zillians MMO
 * Copyright (C) 2007-2010 Zillians.com, Inc.
 * For more information see http://www.zillians.com
 *
 * Zillians MMO is the library and runtime for massive multiplayer online game
 * development in utility computing model, which runs as a service for every
 * developer to build their virtual world running on our GPU-assisted machines.
 *
 * This is a close source library intended to be used solely within Zillians.com
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
/**
 * @date Apr 29, 2010 sdk - Initial version created.
 */

#ifndef ZILLIANS_VW_PROCESSORS_CUDA_DETAIL_THRUSTKERNEL_H_
#define ZILLIANS_VW_PROCESSORS_CUDA_DETAIL_THRUSTKERNEL_H_

#include <stdint.h>

namespace zillians { namespace vw { namespace processors { namespace cuda { namespace detail {

//////////////////////////////////////////////////////////////////////////
/// Prefix Sum (Scan)

struct scan_op { enum type { maximum, minimum, plus, multiply }; };

template <typename T>
void thrust_exclusive_scan(T* input, T* output, const T& init, std::size_t size, scan_op::type op = scan_op::plus);

template<typename T>
void thrust_inclusive_scan(T* input, T* output, std::size_t size, scan_op::type op = scan_op::plus);



//////////////////////////////////////////////////////////////////////////
/// Segmented Prefix Sum (Segmented Scan)

struct segmentation_pred { enum type { equal_to, not_equal_to, greater, less, greater_equal, less_equal }; };

template<typename Key, typename Value>
void thrust_exclusive_segmented_scan(Key* key, Value* data, Value* result, const Value& init, std::size_t size, scan_op::type op, segmentation_pred::type pred);

template<typename Key, typename Value>
void thrust_inclusive_segmented_scan(Key* key, Value* data, Value* result, std::size_t size, scan_op::type op, segmentation_pred::type pred);



//////////////////////////////////////////////////////////////////////////
/// Sort/Stable Sort

struct sort_op { enum type { greater, less, greater_equal, less_equal }; };

template<typename T>
void thrust_sort(T* data, std::size_t size, sort_op::type op = sort_op::less);

template<typename Key, typename Value>
void thrust_sort_by_key(Key* key, Value* data, std::size_t size, sort_op::type op = sort_op::less);

template<typename T>
void thrust_stable_sort(T* data, std::size_t size, sort_op::type op = sort_op::less);

template<typename Key, typename Value>
void thrust_stable_sort_by_key(Key* key, Value* data, std::size_t size, sort_op::type op = sort_op::less);

//////////////////////////////////////////////////////////////////////////
/// Count
template<typename T>
std::size_t thrust_count_if_equal_to(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_not_equal_to(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_odd(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_even(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_multiple_of(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_smaller_then(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_greater_then(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_smaller_then_or_equal_to(T* data, std::size_t size, const T& value);

template<typename T>
std::size_t thrust_count_if_greater_then_or_equal_to(T* data, std::size_t size, const T& value);

//////////////////////////////////////////////////////////////////////////
/// Min/Max
template<typename T>
void thrust_min_element(T* data, std::size_t size, T** min_ptr);

template<typename T>
void thrust_max_element(T* data, std::size_t size, T** max_ptr);

template<typename T>
void thrust_minmax_element(T* data, std::size_t size, T** min_ptr, T** max_ptr);

} } } } } /*zillians::vw::processors::cuda::detail*/

#endif /* ZILLIANS_VW_PROCESSORS_CUDA_DETAIL_THRUSTKERNEL_H_ */
