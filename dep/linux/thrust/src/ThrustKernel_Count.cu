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
#include <thrust/count.h>

namespace zillians { namespace vw { namespace processors { namespace cuda { namespace detail {

//////////////////////////////////////////////////////////////////////////
/// Count
struct CountPredicate
{
	template<typename T>
	struct is_odd : thrust::unary_function<T, bool>
	{
		__host__ __device__
		bool operator()(const T& x)
		{
			return (x & 1);
			//return !(x % 2 == 0);
			//return true;
		}
	};

	template<typename T>
	struct is_even : thrust::unary_function<T, bool>
	{
		__host__ __device__
		bool operator()(const T& x)
		{
			return !(x & 1);
			//return (x % 2 == 0);
			//return true;
		}
	};

	template<typename T>
	struct is_equal_to : thrust::unary_function<T, bool>
	{
		__host__ __device__
		is_equal_to(T value) : rhs(value) { }

		__host__ __device__
		bool operator()(const T& lhs)
		{
			return lhs == rhs;
		}
		T rhs;
	};

	template<typename T>
	struct is_not_equal_to : thrust::unary_function<T, bool>
	{
		__host__ __device__
		is_not_equal_to(T value) : rhs(value) { }

		__host__ __device__
		bool operator()(const T& lhs)
		{
			return lhs != rhs;
		}
		T rhs;
	};

	template<typename T>
	struct is_multiple_of : thrust::unary_function<T, bool>
	{
		__host__ __device__
		is_multiple_of(T value) : multiple(value) { }

		__host__ __device__
		bool operator()(const T& x)
		{
			return x % multiple == 0;
		}
		T multiple;
	};

	template<typename T>
	struct is_smaller_then : thrust::unary_function<T, bool>
	{
		__host__ __device__
		is_smaller_then(T value) : v(value) { }

		__host__ __device__
		bool operator()(const T& x)
		{
			return x < v;
		}
		T v;
	};

	template<typename T>
	struct is_greater_then : thrust::unary_function<T, bool>
	{
		__host__ __device__
		is_greater_then(T value) : v(value) { }

		__host__ __device__
		bool operator()(const T& x)
		{
			return x > v;
		}
		T v;
	};

	template<typename T>
	struct is_smaller_then_or_equal_to : thrust::unary_function<T, bool>
	{
		__host__ __device__
		is_smaller_then_or_equal_to(T value) : v(value) { }

		__host__ __device__
		bool operator()(const T& x)
		{
			return x <= v;
		}
		T v;
	};

	template<typename T>
	struct is_greater_then_or_equal_to : thrust::unary_function<T, bool>
	{
		__host__ __device__
		is_greater_then_or_equal_to(T value) : v(value) { }

		__host__ __device__
		bool operator()(const T& x)
		{
			return x >= v;
		}
		T v;
	};

//	template<typename T>
//	struct is_finite_float32
//	{
//		__device__
//		bool operator()(const T& x)
//		{
//			uint flag;
//			__asm(
//					".reg .pred __internal_pred;"
//					".reg .u32 __internal_flag;"
//					"testp.finite.f32 __internal_pred, %1"
//					"@__internal_pred mov.u32 __internal_flag,1;"
//					"@!__internal_pred mov.u32 __internal_flag,0;"
//					"mov %0, __internal_flag;" : "=r"(flag) : "f"(x) :
//			);
//			return flag == 0;
//		}
//	};

//	template<typename T>
//	struct is_finite_float64
//	{
//		__device__
//		bool operator()(const T& x)
//		{
//			uint flag;
//			__asm(
//					".reg .pred __internal_pred;"
//					".reg .u32 __internal_flag;"
//					"testp.finite.f64 __internal_pred, %1"
//					"@__internal_pred mov.u32 __internal_flag,1;"
//					"@!__internal_pred mov.u32 __internal_flag,0;"
//					"mov %0, __internal_flag;" : "=r"(flag) : "d"(x) :
//			);
//			return flag == 0;
//		}
//	};

	template<typename T>
	struct is_infinite_float
	{
		__device__
		bool operator()(const T& x)
		{
			return false;
		}
	};

	template<typename T>
	struct is_not_nan_float
	{
		__device__
		bool operator()(const T& x)
		{
			return false;
		}
	};

	template<typename T>
	struct is_nan_float
	{
		__device__
		bool operator()(const T& x)
		{
			return false;
		}
	};

	template<typename T>
	struct is_normal_float
	{
		__device__
		bool operator()(const T& x)
		{
			return false;
		}
	};

	template<typename T>
	struct is_subnormal_float
	{
		__device__
		bool operator()(const T& x)
		{
			return false;
		}
	};
};

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_equal_to(T* data, std::size_t size, const T& value)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_equal_to<T>(value));
}

void __dummy_thrust_count_if_equal_to()
{
	thrust_count_if_equal_to<short>                 (NULL, 0, 0);
	thrust_count_if_equal_to<unsigned short>        (NULL, 0, 0);
	thrust_count_if_equal_to<int>                   (NULL, 0, 0);
	thrust_count_if_equal_to<unsigned int>          (NULL, 0, 0);
	thrust_count_if_equal_to<long long int>         (NULL, 0, 0);
	thrust_count_if_equal_to<unsigned long long int>(NULL, 0, 0);
	thrust_count_if_equal_to<float>                 (NULL, 0, 0.0f);
	thrust_count_if_equal_to<double>                (NULL, 0, 0.0);
	thrust_count_if_equal_to<uint32_t>                (NULL, 0, 0.0);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_not_equal_to(T* data, std::size_t size, const T& value)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_not_equal_to<T>(value));
}

void __dummy_thrust_count_if_not_equal_to()
{
	thrust_count_if_not_equal_to<short>                 (NULL, 0, 0);
	thrust_count_if_not_equal_to<unsigned short>        (NULL, 0, 0);
	thrust_count_if_not_equal_to<int>                   (NULL, 0, 0);
	thrust_count_if_not_equal_to<unsigned int>          (NULL, 0, 0);
	thrust_count_if_not_equal_to<long long int>         (NULL, 0, 0);
	thrust_count_if_not_equal_to<unsigned long long int>(NULL, 0, 0);
	thrust_count_if_not_equal_to<float>                 (NULL, 0, 0.0f);
	thrust_count_if_not_equal_to<double>                (NULL, 0, 0.0);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_odd(T* data, std::size_t size)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_odd<T>());
}

void __dummy_thrust_count_if_odd()
{
	thrust_count_if_odd<short>                 (NULL, 0);
	thrust_count_if_odd<unsigned short>        (NULL, 0);
	thrust_count_if_odd<int>                   (NULL, 0);
	thrust_count_if_odd<unsigned int>          (NULL, 0);
	thrust_count_if_odd<long long int>         (NULL, 0);
	thrust_count_if_odd<unsigned long long int>(NULL, 0);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_even(T* data, std::size_t size)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_even<T>());
}

void __dummy_thrust_count_if_even()
{
	thrust_count_if_even<short>                 (NULL, 0);
	thrust_count_if_even<unsigned short>        (NULL, 0);
	thrust_count_if_even<int>                   (NULL, 0);
	thrust_count_if_even<unsigned int>          (NULL, 0);
	thrust_count_if_even<long long int>         (NULL, 0);
	thrust_count_if_even<unsigned long long int>(NULL, 0);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_multiple_of(T* data, std::size_t size, const T& value)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_multiple_of<T>(value));
}

void __dummy_thrust_count_if_multiple_of()
{
	thrust_count_if_multiple_of<short>                 (NULL, 0, 1);
	thrust_count_if_multiple_of<unsigned short>        (NULL, 0, 1);
	thrust_count_if_multiple_of<int>                   (NULL, 0, 1);
	thrust_count_if_multiple_of<unsigned int>          (NULL, 0, 1);
	thrust_count_if_multiple_of<long long int>         (NULL, 0, 1);
	thrust_count_if_multiple_of<unsigned long long int>(NULL, 0, 1);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_smaller_then(T* data, std::size_t size, const T& value)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_smaller_then<T>(value));
}

void __dummy_thrust_count_if_smaller_then()
{
	thrust_count_if_smaller_then<short>                 (NULL, 0, 0);
	thrust_count_if_smaller_then<unsigned short>        (NULL, 0, 0);
	thrust_count_if_smaller_then<int>                   (NULL, 0, 0);
	thrust_count_if_smaller_then<unsigned int>          (NULL, 0, 0);
	thrust_count_if_smaller_then<long long int>         (NULL, 0, 0);
	thrust_count_if_smaller_then<unsigned long long int>(NULL, 0, 0);
	thrust_count_if_smaller_then<float>                 (NULL, 0, 0.0f);
	thrust_count_if_smaller_then<double>                (NULL, 0, 0.0);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_greater_then(T* data, std::size_t size, const T& value)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_greater_then<T>(value));
}

void __dummy_thrust_count_if_greater_then()
{
	thrust_count_if_greater_then<short>                 (NULL, 0, 0);
	thrust_count_if_greater_then<unsigned short>        (NULL, 0, 0);
	thrust_count_if_greater_then<int>                   (NULL, 0, 0);
	thrust_count_if_greater_then<unsigned int>          (NULL, 0, 0);
	thrust_count_if_greater_then<long long int>         (NULL, 0, 0);
	thrust_count_if_greater_then<unsigned long long int>(NULL, 0, 0);
	thrust_count_if_greater_then<float>                 (NULL, 0, 0.0f);
	thrust_count_if_greater_then<double>                (NULL, 0, 0.0);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_smaller_then_or_equal_to(T* data, std::size_t size, const T& value)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_smaller_then_or_equal_to<T>(value));
}

void __dummy_thrust_count_if_smaller_then_or_equal_to()
{
	thrust_count_if_smaller_then_or_equal_to<short>                 (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<unsigned short>        (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<int>                   (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<unsigned int>          (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<long long int>         (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<unsigned long long int>(NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<float>                 (NULL, 0, 0.0f);
	thrust_count_if_smaller_then_or_equal_to<double>                (NULL, 0, 0.0);
}

template<typename T>
std::size_t __attribute__((noinline)) thrust_count_if_greater_then_or_equal_to(T* data, std::size_t size, const T& value)
{
	thrust::device_ptr<T> dp_data(data);
	return thrust::count_if(dp_data, dp_data + size, CountPredicate::is_greater_then_or_equal_to<T>(value));
}

void __dummy_thrust_count_if_greater_then_or_equal_to()
{
	thrust_count_if_smaller_then_or_equal_to<short>                 (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<unsigned short>        (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<int>                   (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<unsigned int>          (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<long long int>         (NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<unsigned long long int>(NULL, 0, 0);
	thrust_count_if_smaller_then_or_equal_to<float>                 (NULL, 0, 0.0f);
	thrust_count_if_smaller_then_or_equal_to<double>                (NULL, 0, 0.0);
}

} } } } }
