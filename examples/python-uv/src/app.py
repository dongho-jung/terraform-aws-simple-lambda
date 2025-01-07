import dns.resolver
import pendulum


def main(event, context):
    # print UTC time
    print(pendulum.now('UTC'))

    # print DNS response
    answer = dns.resolver.resolve("test.jungdong.com", "A")
    print(answer.response.answer)


if __name__ == "__main__":
    main(None, None)
