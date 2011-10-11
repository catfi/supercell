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
 * @date May 21, 2010 sdk - Initial version created.
 */

#include "ThrustKernel.h"

#include <thrust/version.h>
#include <thrust/device_ptr.h>
#include <thrust/device_vector.h>
#include <thrust/functional.h>
#include <thrust/scan.h>

namespace zillians { namespace vw { namespace processors { namespace cuda { namespace detail {

//////////////////////////////////////////////////////////////////////////
/// Segmented Prefix Sum (Segmented Scan)
template<typename Key, typename Value>
void __attribute__((noinline)) thrust_exclusive_segmented_scan(Key* key, Value* data, Value* result, const Value& init, std::size_t size, scan_op::type op, segmentation_pred::type pred)
{
	thrust::device_ptr<Key> dp_key(key);
	thrust::device_ptr<Value> dp_data(data);
	thrust::device_ptr<Value> dp_result(result);

#if THRUST_MAJOR_VERSION <= 1 && THRUST_MINOR_VERSION < 3
	if(op == scan_op::maximum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::minimum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::plus)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::multiply)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::exclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else
	{
		throw std::invalid_argument("invalid segmented scan operator");
	}
#else
	if(op == scan_op::maximum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::maximum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::minimum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::minimum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::plus)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::plus<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::multiply)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::exclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, init, thrust::multiplies<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else
	{
		throw std::invalid_argument("invalid segmented scan operator");
	}
#endif
}

template<typename Key, typename Value>
void __attribute__((noinline)) thrust_inclusive_segmented_scan(Key* key, Value* data, Value* result, std::size_t size, scan_op::type op, segmentation_pred::type pred)
{
	thrust::device_ptr<Key> dp_key(key);
	thrust::device_ptr<Value> dp_data(data);
	thrust::device_ptr<Value> dp_result(result);

#if THRUST_MAJOR_VERSION <= 1 && THRUST_MINOR_VERSION < 3
	if(op == scan_op::maximum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::minimum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::plus)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::multiply)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::experimental::inclusive_segmented_scan(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else
	{
		throw std::invalid_argument("invalid segmented scan operator");
	}
#else
	if(op == scan_op::maximum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::maximum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::minimum)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::minimum<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::plus)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::plus<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else if(op == scan_op::multiply)
	{
		if(pred == segmentation_pred::equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::equal_to<Key>());
		else if(pred == segmentation_pred::not_equal_to)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::not_equal_to<Key>());
		else if(pred == segmentation_pred::greater)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::greater<Key>());
		else if(pred == segmentation_pred::less)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::less<Key>());
		else if(pred == segmentation_pred::greater_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::greater_equal<Key>());
		else if(pred == segmentation_pred::less_equal)
			thrust::inclusive_scan_by_key(dp_data, dp_data + size, dp_key, dp_result, thrust::multiplies<Value>(), thrust::less_equal<Key>());
		else
			throw std::invalid_argument("invalid segmented scan predicate");
	}
	else
	{
		throw std::invalid_argument("invalid segmented scan operator");
	}
#endif
}

void __dummy_thrust_exclusive_segmented_scan()
{
	thrust_exclusive_segmented_scan<short,short>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,unsigned short>        (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,int>                   (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,unsigned int>          (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,long long int>         (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,unsigned long long int>(NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,float>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,double>                (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_exclusive_segmented_scan<short,short>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,unsigned short>        (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,int>                   (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,unsigned int>          (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,long long int>         (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,unsigned long long int>(NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,float>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<short,double>                (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_exclusive_segmented_scan<unsigned short,short>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned short,unsigned short>        (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned short,int>                   (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned short,unsigned int>          (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned short,long long int>         (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned short,unsigned long long int>(NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned short,float>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned short,double>                (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_exclusive_segmented_scan<int,short>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<int,unsigned short>        (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<int,int>                   (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<int,unsigned int>          (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<int,long long int>         (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<int,unsigned long long int>(NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<int,float>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<int,double>                (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_exclusive_segmented_scan<unsigned int,short>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned int,unsigned short>        (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned int,int>                   (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned int,unsigned int>          (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned int,long long int>         (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned int,unsigned long long int>(NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned int,float>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned int,double>                (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_exclusive_segmented_scan<long long int,short>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<long long int,unsigned short>        (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<long long int,int>                   (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<long long int,unsigned int>          (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<long long int,long long int>         (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<long long int,unsigned long long int>(NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<long long int,float>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<long long int,double>                (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_exclusive_segmented_scan<unsigned long long int,short>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned long long int,unsigned short>        (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned long long int,int>                   (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned long long int,unsigned int>          (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned long long int,long long int>         (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned long long int,unsigned long long int>(NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned long long int,float>                 (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_exclusive_segmented_scan<unsigned long long int,double>                (NULL, NULL, NULL, 0, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_inclusive_segmented_scan<short,short>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<short,unsigned short>        (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<short,int>                   (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<short,unsigned int>          (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<short,long long int>         (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<short,unsigned long long int>(NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<short,float>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<short,double>                (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_inclusive_segmented_scan<unsigned short,short>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned short,unsigned short>        (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned short,int>                   (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned short,unsigned int>          (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned short,long long int>         (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned short,unsigned long long int>(NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned short,float>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned short,double>                (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_inclusive_segmented_scan<int,short>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<int,unsigned short>        (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<int,int>                   (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<int,unsigned int>          (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<int,long long int>         (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<int,unsigned long long int>(NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<int,float>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<int,double>                (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_inclusive_segmented_scan<unsigned int,short>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned int,unsigned short>        (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned int,int>                   (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned int,unsigned int>          (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned int,long long int>         (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned int,unsigned long long int>(NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned int,float>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned int,double>                (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_inclusive_segmented_scan<long long int,short>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<long long int,unsigned short>        (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<long long int,int>                   (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<long long int,unsigned int>          (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<long long int,long long int>         (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<long long int,unsigned long long int>(NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<long long int,float>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<long long int,double>                (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);

	thrust_inclusive_segmented_scan<unsigned long long int,short>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned long long int,unsigned short>        (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned long long int,int>                   (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned long long int,unsigned int>          (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned long long int,long long int>         (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned long long int,unsigned long long int>(NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned long long int,float>                 (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
	thrust_inclusive_segmented_scan<unsigned long long int,double>                (NULL, NULL, NULL, 0, scan_op::plus, segmentation_pred::equal_to);
}

} } } } }
