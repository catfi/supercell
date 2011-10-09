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
#include <thrust/extrema.h>

namespace zillians { namespace vw { namespace processors { namespace cuda { namespace detail {

//////////////////////////////////////////////////////////////////////////
/// Min/Max
template<typename T>
void __attribute__((noinline)) thrust_min_element(T* data, std::size_t size, T** min_ptr)
{
	thrust::device_ptr<T> dp_data(data);
	thrust::device_ptr<T> min_it = thrust::min_element(dp_data, dp_data + size);
	*min_ptr = min_it.get();
}

void __dummy_thrust_min_element()
{
	thrust_min_element<short>                 (NULL, 0, NULL);
	thrust_min_element<unsigned short>        (NULL, 0, NULL);
	thrust_min_element<int>                   (NULL, 0, NULL);
	thrust_min_element<unsigned int>          (NULL, 0, NULL);
	thrust_min_element<long long int>         (NULL, 0, NULL);
	thrust_min_element<unsigned long long int>(NULL, 0, NULL);
	thrust_min_element<float>                 (NULL, 0, NULL);
	thrust_min_element<double>                (NULL, 0, NULL);
}

template<typename T>
void __attribute__((noinline)) thrust_max_element(T* data, std::size_t size, T** max_ptr)
{
	thrust::device_ptr<T> dp_data(data);
	thrust::device_ptr<T> max_it = thrust::max_element(dp_data, dp_data + size);
	*max_ptr = max_it.get();
}

void __dummy_thrust_max_element()
{
	thrust_max_element<short>                 (NULL, 0, NULL);
	thrust_max_element<unsigned short>        (NULL, 0, NULL);
	thrust_max_element<int>                   (NULL, 0, NULL);
	thrust_max_element<unsigned int>          (NULL, 0, NULL);
	thrust_max_element<long long int>         (NULL, 0, NULL);
	thrust_max_element<unsigned long long int>(NULL, 0, NULL);
	thrust_max_element<float>                 (NULL, 0, NULL);
	thrust_max_element<double>                (NULL, 0, NULL);
}

template<typename T>
void __attribute__((noinline)) thrust_minmax_element(T* data, std::size_t size, T** min_ptr, T** max_ptr)
{
	thrust::device_ptr<T> dp_data(data);
	thrust::pair< thrust::device_ptr<T>, thrust::device_ptr<T> > result = thrust::minmax_element(dp_data, dp_data + size);
	*min_ptr = result.first.get();
	*max_ptr = result.second.get();
}

void __dummy_thrust_minmax_element()
{
	thrust_minmax_element<short>                 (NULL, 0, NULL, NULL);
	thrust_minmax_element<unsigned short>        (NULL, 0, NULL, NULL);
	thrust_minmax_element<int>                   (NULL, 0, NULL, NULL);
	thrust_minmax_element<unsigned int>          (NULL, 0, NULL, NULL);
	thrust_minmax_element<long long int>         (NULL, 0, NULL, NULL);
	thrust_minmax_element<unsigned long long int>(NULL, 0, NULL, NULL);
	thrust_minmax_element<float>                 (NULL, 0, NULL, NULL);
	thrust_minmax_element<double>                (NULL, 0, NULL, NULL);
}

} } } } }
