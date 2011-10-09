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
/// Prefix Sum (Scan)

template<typename T>
void __attribute__((noinline)) thrust_exclusive_scan(T* input, T* output, const T& init, std::size_t size, scan_op::type op)
{
	thrust::device_ptr<T> dp_input(input);
	thrust::device_ptr<T> dp_output(output);

	if(op == scan_op::maximum)
	{
		thrust::exclusive_scan(dp_input, dp_input + size, dp_output, init, thrust::maximum<T>());
	}
	else if(op == scan_op::minimum)
	{
		thrust::exclusive_scan(dp_input, dp_input + size, dp_output, init, thrust::minimum<T>());
	}
	else if(op == scan_op::plus)
	{
		thrust::exclusive_scan(dp_input, dp_input + size, dp_output, init, thrust::plus<T>());
	}
	else if(op == scan_op::multiply)
	{
		thrust::exclusive_scan(dp_input, dp_input + size, dp_output, init, thrust::multiplies<T>());
	}
	else
	{
		throw std::invalid_argument("invalid exclusive scan operator");
	}
}

void __dummy_thrust_exclusive_scan()
{
	thrust_exclusive_scan<short>                 (NULL, NULL, 0, 0, scan_op::maximum);
	thrust_exclusive_scan<unsigned short>        (NULL, NULL, 0, 0, scan_op::maximum);
	thrust_exclusive_scan<int>                   (NULL, NULL, 0, 0, scan_op::maximum);
	thrust_exclusive_scan<unsigned int>          (NULL, NULL, 0, 0, scan_op::maximum);
	thrust_exclusive_scan<long long int>         (NULL, NULL, 0, 0, scan_op::maximum);
	thrust_exclusive_scan<unsigned long long int>(NULL, NULL, 0, 0, scan_op::maximum);
	thrust_exclusive_scan<float>                 (NULL, NULL, 0.0f, 0, scan_op::maximum);
	thrust_exclusive_scan<double>                (NULL, NULL, 0.0, 0, scan_op::maximum);
}

template<typename T>
void __attribute__((noinline)) thrust_inclusive_scan(T* input, T* output, std::size_t size, scan_op::type op)
{
	thrust::device_ptr<T> dp_input(input);
	thrust::device_ptr<T> dp_output(output);

	if(op == scan_op::maximum)
	{
		thrust::inclusive_scan(dp_input, dp_input + size, dp_output, thrust::maximum<T>());
	}
	else if(op == scan_op::minimum)
	{
		thrust::inclusive_scan(dp_input, dp_input + size, dp_output, thrust::minimum<T>());
	}
	else if(op == scan_op::plus)
	{
		thrust::inclusive_scan(dp_input, dp_input + size, dp_output, thrust::plus<T>());
	}
	else if(op == scan_op::multiply)
	{
		thrust::inclusive_scan(dp_input, dp_input + size, dp_output, thrust::multiplies<T>());
	}
	else
	{
		throw std::invalid_argument("invalid inclusive scan operator");
	}
}

void __dummy_thrust_inclusive_scan()
{
	thrust_inclusive_scan<short>                 (NULL, NULL, 0, scan_op::maximum);
	thrust_inclusive_scan<unsigned short>        (NULL, NULL, 0, scan_op::maximum);
	thrust_inclusive_scan<int>                   (NULL, NULL, 0, scan_op::maximum);
	thrust_inclusive_scan<unsigned int>          (NULL, NULL, 0, scan_op::maximum);
	thrust_inclusive_scan<long long int>         (NULL, NULL, 0, scan_op::maximum);
	thrust_inclusive_scan<unsigned long long int>(NULL, NULL, 0, scan_op::maximum);
	thrust_inclusive_scan<float>                 (NULL, NULL, 0, scan_op::maximum);
	thrust_inclusive_scan<double>                (NULL, NULL, 0, scan_op::maximum);
}

} } } } }

