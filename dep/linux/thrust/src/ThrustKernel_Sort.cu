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
#include <thrust/sort.h>

namespace zillians { namespace vw { namespace processors { namespace cuda { namespace detail {

//////////////////////////////////////////////////////////////////////////
/// Radix Sort Sort
template<typename T>
void __attribute__((noinline)) thrust_sort(T* data, std::size_t size, sort_op::type op)
{
	thrust::device_ptr<T> dp_data(data);

	if(op == sort_op::greater)
	{
		thrust::sort(dp_data, dp_data + size, thrust::greater<T>());
	}
	else if(op == sort_op::less)
	{
		thrust::sort(dp_data, dp_data + size, thrust::less<T>());
	}
	else if(op == sort_op::greater_equal)
	{
		thrust::sort(dp_data, dp_data + size, thrust::greater_equal<T>());
	}
	else if(op == sort_op::less_equal)
	{
		thrust::sort(dp_data, dp_data + size, thrust::less_equal<T>());
	}
	else
	{
		throw std::invalid_argument("invalid sort operator");
	}
}

template<typename Key, typename Value>
void __attribute__((noinline)) thrust_sort_by_key(Key* key, Value* data, std::size_t size, sort_op::type op)
{
	thrust::device_ptr<Key> dp_key(key);
	thrust::device_ptr<Value> dp_data(data);

	if(op == sort_op::greater)
	{
		thrust::sort_by_key(dp_key, dp_key + size, dp_data, thrust::greater<Key>());
	}
	else if(op == sort_op::less)
	{
		thrust::sort_by_key(dp_key, dp_key + size, dp_data, thrust::less<Key>());
	}
	else if(op == sort_op::greater_equal)
	{
		thrust::sort_by_key(dp_key, dp_key + size, dp_data, thrust::greater_equal<Key>());
	}
	else if(op == sort_op::less_equal)
	{
		thrust::sort_by_key(dp_key, dp_key + size, dp_data, thrust::less_equal<Key>());
	}
	else
	{
		throw std::invalid_argument("invalid sort operator");
	}
}

void __dummy_thrust_sort()
{
	thrust_sort<short>                 (NULL, 0, sort_op::greater);
	thrust_sort<unsigned short>        (NULL, 0, sort_op::greater);
	thrust_sort<int>                   (NULL, 0, sort_op::greater);
	thrust_sort<unsigned int>          (NULL, 0, sort_op::greater);
	thrust_sort<long long int>         (NULL, 0, sort_op::greater);
	thrust_sort<unsigned long long int>(NULL, 0, sort_op::greater);
	thrust_sort<float>                 (NULL, 0, sort_op::greater);
	thrust_sort<double>                (NULL, 0, sort_op::greater);

	thrust_sort_by_key<short, short>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<short, unsigned short>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<short, int>                 		(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<short, unsigned int>             (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<short, long long int>            (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<short, unsigned long long int>   (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<short, float>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<short, double>                 	(NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<unsigned short, short>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned short, unsigned short>          (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned short, int>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned short, unsigned int>            (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned short, long long int>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned short, unsigned long long int>  (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned short, float>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned short, double>                 	(NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<int, short>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<int, unsigned short>         (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<int, int>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<int, unsigned int>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<int, long long int>          (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<int, unsigned long long int> (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<int, float>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<int, double>                 (NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<unsigned int, short>                  (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned int, unsigned short>         (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned int, int>                 	 (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned int, unsigned int>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned int, long long int>          (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned int, unsigned long long int> (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned int, float>                  (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned int, double>                 (NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<long long int, short>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<long long int, unsigned short>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<long long int, int>                 		(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<long long int, unsigned int>             (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<long long int, long long int>            (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<long long int, unsigned long long int>   (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<long long int, float>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<long long int, double>                 	(NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<unsigned long long int, short>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned long long int, unsigned short>          (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned long long int, int>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned long long int, unsigned int>            (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned long long int, long long int>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned long long int, unsigned long long int>  (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned long long int, float>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<unsigned long long int, double>                 	(NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<float, short>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<float, unsigned short>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<float, int>                 		(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<float, unsigned int>             (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<float, long long int>            (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<float, unsigned long long int>   (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<float, float>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<float, double>                 	(NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<double, short>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<double, unsigned short>          (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<double, int>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<double, unsigned int>            (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<double, long long int>           (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<double, unsigned long long int>  (NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<double, float>                 	(NULL, NULL, 0, sort_op::greater);
	thrust_sort_by_key<double, double>                 	(NULL, NULL, 0, sort_op::greater);

	thrust_sort_by_key<uint64_t, uint32_t>                 	(NULL, NULL, 0, sort_op::greater);
}

} } } } }
